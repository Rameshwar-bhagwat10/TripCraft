# TripCraft Component Usage Guidelines

## Buttons
- **PrimaryButton**: Main CTAs (`#0F766E`, white text, 48px height, 12px radius).
- **SecondaryButton**: Secondary CTAs (`#F0FDFA` background, `#0F766E` text).
- **TertiaryButton**: Subtle text buttons without container backgrounds.
- **DestructiveButton**: Destructive actions (`#DC2626`).
- **AppIconButton**: 48x48 touch targets for standalone icon actions.

## Inputs
- **AppTextField**: Standard form text input with error and disabled state handlers.
- **SearchField**: Search bar with Phosphor magnifying glass and clear actions.
- **DatePickerField**: Date selection container with calendar icon.

## Cards & Containers
- **AppCard**: Surface card with `#FFFFFF` background, 16px radius, and subtle border.
- **GlassCard**: Specialized visual container with subtle backdrop blur.

## Feedback & States
- **EmptyState**: Clean placeholder for empty screens.
- **ErrorState**: Retry card for network or API failures.
- **OfflineState**: Network disconnect state banner.
- **AppSnackBar**: Floating feedback toasts for Success, Warning, Error, and Info.