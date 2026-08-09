import { createParamDecorator, ExecutionContext } from '@nestjs/common';

export interface UserContext {
  id: string;
  email: string;
  fullName?: string;
  avatarUrl?: string;
}

export const CurrentUser = createParamDecorator(
  (data: unknown, ctx: ExecutionContext): UserContext => {
    const request = ctx.switchToHttp().getRequest();
    return request.user;
  },
);
