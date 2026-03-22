---
name: nestjs-rabbitmq-worker
description: Set up RabbitMQ consumer for background job processing in NestJS worker service
license: MIT
compatibility: opencode
metadata:
  audience: developers
  workflow: nestjs
---

## What I do

- Manage RabbitMQ connection with automatic reconnection
- Create queues and consume messages
- Process background jobs asynchronously
- Publish messages from API to worker queues

## When to use me

Use this for background job processing (email sending, notifications, data processing). Combine with nestjs-email-service for async email.

## RabbitMQ Service

```typescript
import { Injectable, OnModuleInit, OnModuleDestroy, Logger } from '@nestjs/common';
import * as amqp from 'amqplib';

@Injectable()
export class RabbitMQService implements OnModuleInit, OnModuleDestroy {
  private connection: amqp.Connection;
  private channel: amqp.Channel;
  private readonly logger = new Logger(RabbitMQService.name);
  private readonly url: string;

  constructor() {
    this.url = process.env.RABBITMQ_URL || 'amqp://localhost:5672';
  }

  async onModuleInit() {
    await this.connect();
  }

  async onModuleDestroy() {
    await this.close();
  }

  private async connect() {
    try {
      this.connection = await amqp.connect(this.url);
      this.channel = await this.connection.createChannel();
      this.logger.log('Connected to RabbitMQ');

      this.connection.on('error', (err) => {
        this.logger.error('RabbitMQ connection error', err);
      });

      this.connection.on('close', () => {
        this.logger.warn('RabbitMQ connection closed, reconnecting...');
        setTimeout(() => this.connect(), 5000);
      });
    } catch (error) {
      this.logger.error('Failed to connect to RabbitMQ', error);
    }
  }

  async createQueue(queueName: string, options?: amqp.Options.AssertQueue) {
    await this.channel.assertQueue(queueName, options || { durable: true });
  }

  async consume(queueName: string, callback: (msg: amqp.ConsumeMessage) => void) {
    await this.channel.consume(queueName, callback, { noAck: false });
  }

  async ack(message: amqp.ConsumeMessage) {
    this.channel.ack(message);
  }

  async nack(message: amqp.ConsumeMessage, requeue = true) {
    this.channel.nack(message, false, requeue);
  }

  async publish(queueName: string, message: object) {
    const buffer = Buffer.from(JSON.stringify(message));
    this.channel.sendToQueue(queueName, buffer, { persistent: true });
  }

  private async close() {
    try {
      await this.channel.close();
      await this.connection.close();
    } catch (error) {
      this.logger.error('Error closing RabbitMQ connection', error);
    }
  }
}
```

## Email Worker Service

```typescript
import { Injectable, Logger } from '@nestjs/common';
import { RabbitMQService } from 'src/rabbitmq/rabbitmq.service';
import * as amqp from 'amqplib';

export const EMAIL_QUEUE = 'email_queue';

@Injectable()
export class EmailWorkerService {
  private readonly logger = new Logger(EmailWorkerService.name);

  constructor(private readonly rabbitMQService: RabbitMQService) {}

  async onModuleInit() {
    await this.setupQueues();
    await this.startConsuming();
  }

  private async setupQueues() {
    await this.rabbitMQService.createQueue(EMAIL_QUEUE);
    this.logger.log(`Queue ${EMAIL_QUEUE} created`);
  }

  private async startConsuming() {
    await this.rabbitMQService.consume(EMAIL_QUEUE, async (msg: amqp.ConsumeMessage) => {
      try {
        const emailData = JSON.parse(msg.content.toString());
        this.logger.log(`Processing email: ${emailData.to}`);

        await this.processEmail(emailData);

        await this.rabbitMQService.ack(msg);
        this.logger.log(`Email sent successfully to ${emailData.to}`);
      } catch (error) {
        this.logger.error(`Failed to process email: ${error.message}`);
        await this.rabbitMQService.nack(msg, true);
      }
    });

    this.logger.log(`Started consuming from ${EMAIL_QUEUE}`);
  }

  private async processEmail(data: { to: string; subject: string; body: string }) {
    this.logger.log(`Sending email to ${data.to}: ${data.subject}`);
  }
}
```

## Email Producer Service

```typescript
import { Injectable } from '@nestjs/common';
import { RabbitMQService } from 'src/rabbitmq/rabbitmq.service';
import { EMAIL_QUEUE } from './email-worker.service';

@Injectable()
export class EmailProducerService {
  constructor(private readonly rabbitMQService: RabbitMQService) {}

  async sendWelcomeEmail(userEmail: string, userName: string) {
    const message = {
      to: userEmail,
      subject: 'Welcome to our platform!',
      body: `Hello ${userName}, welcome to our platform!`,
      template: 'welcome',
    };

    await this.rabbitMQService.publish(EMAIL_QUEUE, message);
    this.logger.log(`Email job queued for ${userEmail}`);
  }

  async sendPasswordResetEmail(email: string, resetToken: string) {
    const message = {
      to: email,
      subject: 'Password Reset Request',
      body: `Use this token to reset your password: ${resetToken}`,
      template: 'password-reset',
    };

    await this.rabbitMQService.publish(EMAIL_QUEUE, message);
  }
}
```

## Worker Module

```typescript
import { Module } from '@nestjs/common';
import { RabbitMQModule } from 'src/rabbitmq/rabbitmq.module';
import { EmailWorkerService } from './email-worker.service';
import { EmailProducerModule } from 'src/email/email-producer.module';

@Module({
  imports: [RabbitMQModule, EmailProducerModule],
  providers: [EmailWorkerService],
})
export class WorkerModule {}
```

## Docker Compose

```yaml
services:
  rabbitmq:
    image: rabbitmq:3-management
    restart: unless-stopped
    environment:
      RABBITMQ_DEFAULT_USER: ${RABBITMQ_USER}
      RABBITMQ_DEFAULT_PASS: ${RABBITMQ_PASS}
    volumes:
      - rabbitmq_data:/var/lib/rabbitmq
    ports:
      - "5672:5672"
      - "15672:15672"
    networks:
      - internal
```

## Installation

```bash
npm install amqplib amqp-connection-manager
```
