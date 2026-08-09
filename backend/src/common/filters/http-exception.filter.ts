import {
  ExceptionFilter,
  Catch,
  ArgumentsHost,
  HttpException,
  HttpStatus,
  Logger,
} from "@nestjs/common";
import { Request, Response } from "express";

@Catch()
export class GlobalExceptionFilter implements ExceptionFilter {
  private readonly logger = new Logger("GlobalExceptionFilter");

  catch(exception: any, host: ArgumentsHost) {
    const ctx = host.switchToHttp();
    const response = ctx.getResponse<Response>();
    const request = ctx.getRequest<Request>();

    const status =
      exception instanceof HttpException
        ? exception.getStatus()
        : HttpStatus.INTERNAL_SERVER_ERROR;

    const exceptionResponse =
      exception instanceof HttpException
        ? exception.getResponse()
        : { message: exception.message || "Internal server error" };

    const errorDetails =
      typeof exceptionResponse === "string"
        ? { message: exceptionResponse }
        : (exceptionResponse as any);

    // Redact sensitive path elements or log internal details
    this.logger.error(
      `[${request.method}] ${request.url} failed with status ${status}: ${JSON.stringify(errorDetails)}`,
    );

    const responseBody = {
      success: false,
      statusCode: status,
      ...errorDetails,
      timestamp: new Date().toISOString(),
      path: request.url,
    };

    response.status(status).json(responseBody);
  }
}
