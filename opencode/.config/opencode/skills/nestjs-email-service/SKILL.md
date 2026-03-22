---
name: nestjs-email-service
description: Set up email sending with Nodemailer in NestJS for transactional emails
license: MIT
compatibility: opencode
metadata:
  audience: developers
  workflow: nestjs
---

## What I do

- Configure Nodemailer transporter with SMTP settings
- Send transactional emails with HTML/text support
- Render email templates with variable substitution
- Support queue-based email sending via RabbitMQ

## When to use me

Use this when implementing email functionality (welcome emails, password reset, notifications). Consider combining with RabbitMQ for async processing.

## Email Service

```typescript
import { Injectable, Logger } from '@nestjs/common';
import * as nodemailer from 'nodemailer';
import { ConfigService } from '@nestjs/config';

export interface EmailOptions {
  to: string;
  subject: string;
  html?: string;
  text?: string;
}

@Injectable()
export class EmailService {
  private readonly logger = new Logger(EmailService.name);
  private transporter: nodemailer.Transporter;

  constructor(private configService: ConfigService) {
    this.transporter = nodemailer.createTransport({
      host: this.configService.get('SMTP_HOST'),
      port: this.configService.get('SMTP_PORT'),
      secure: this.configService.get('SMTP_PORT') === 465,
      auth: {
        user: this.configService.get('SMTP_USER'),
        pass: this.configService.get('SMTP_PASS'),
      },
    });
  }

  async sendEmail(options: EmailOptions): Promise<void> {
    try {
      const info = await this.transporter.sendMail({
        from: this.configService.get('SES_FROM') || 'noreply@example.com',
        to: options.to,
        subject: options.subject,
        html: options.html,
        text: options.text,
      });

      this.logger.log(`Email sent to ${options.to}: ${info.messageId}`);
    } catch (error) {
      this.logger.error(`Failed to send email to ${options.to}`, error);
      throw error;
    }
  }

  async sendTemplateEmail(to: string, subject: string, template: string, data: object): Promise<void> {
    const html = this.renderTemplate(template, data);
    await this.sendEmail({ to, subject, html });
  }

  private renderTemplate(template: string, data: object): string {
    let html = this.getTemplate(template);
    Object.entries(data).forEach(([key, value]) => {
      html = html.replace(new RegExp(`{{${key}}}`, 'g'), String(value));
    });
    return html;
  }
}
```

## Email Module

```typescript
import { Module } from '@nestjs/common';
import { EmailService } from './email.service';

@Module({
  providers: [EmailService],
  exports: [EmailService],
})
export class EmailModule {}
```

## Sending Welcome Email

```typescript
import { Injectable } from '@nestjs/common';
import { EmailService } from 'src/email/email.service';
import { User } from 'src/user/user.entity';

@Injectable()
export class UserService {
  constructor(private readonly emailService: EmailService) {}

  async createUser(data: CreateUserDto): Promise<User> {
    const user = await this.usersRepository.create(data);

    await this.emailService.sendTemplateEmail(
      user.email,
      'Welcome to our platform!',
      'welcome',
      { name: user.name },
    );

    return user;
  }
}
```

## Queue-based Email (RabbitMQ)

```typescript
import { Injectable } from '@nestjs/common';
import { RabbitMQService } from 'src/rabbitmq/rabbitmq.service';

@Injectable()
export class EmailProducerService {
  constructor(private readonly rabbitMQService: RabbitMQService) {}

  async queueWelcomeEmail(userEmail: string, userName: string) {
    await this.rabbitMQService.publish('email_queue', {
      type: 'welcome',
      to: userEmail,
      data: { name: userName },
    });
  }
}
```

## Environment Variables

```bash
# Email / SMTP
SMTP_HOST=smtp.example.com
SMTP_PORT=587
SMTP_USER=your-smtp-user
SMTP_PASS=your-smtp-password
SES_FROM=noreply@yourdomain.com
```

## Installation

```bash
npm install nodemailer @types/nodemailer
```
