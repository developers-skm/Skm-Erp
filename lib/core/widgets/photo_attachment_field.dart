import 'package:flutter/material.dart';

import '../../app/theme/app_spacing.dart';

/// Placeholder photo-attachment thumbnails + "Add Photo" affordance.
///
/// Actual image picking (camera/gallery) is not wired in this phase —
/// tapping "Add Photo" inserts a labelled placeholder tile so the
/// add/remove interaction can be reviewed. Wire `image_picker` (or
/// similar) here once photo capture is prioritized.
class PhotoAttachmentField extends StatelessWidget {
  const PhotoAttachmentField({
    super.key,
    required this.count,
    required this.onAdd,
    required this.onRemove,
  });

  final int count;
  final VoidCallback onAdd;
  final ValueChanged<int> onRemove;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Photos', style: theme.textTheme.labelLarge),
        const SizedBox(height: AppSpacing.xs),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            for (var i = 0; i < count; i++)
              _Thumbnail(onRemove: () => onRemove(i)),
            _AddPhotoTile(onTap: onAdd),
          ],
        ),
      ],
    );
  }
}

class _Thumbnail extends StatelessWidget {
  const _Thumbnail({required this.onRemove});

  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.image_outlined,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        Positioned(
          right: -6,
          top: -6,
          child: InkWell(
            borderRadius: BorderRadius.circular(999),
            onTap: onRemove,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: theme.colorScheme.error,
                shape: BoxShape.circle,
                border: Border.all(color: theme.colorScheme.surface, width: 2),
              ),
              child: const Icon(
                Icons.close_rounded,
                size: 14,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _AddPhotoTile extends StatelessWidget {
  const _AddPhotoTile({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: theme.colorScheme.outlineVariant),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_a_photo_outlined,
              color: theme.colorScheme.primary,
              size: 20,
            ),
            const SizedBox(height: 2),
            Text(
              'Add Photo',
              style: theme.textTheme.bodySmall?.copyWith(fontSize: 10),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
