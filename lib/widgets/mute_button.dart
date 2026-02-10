import 'package:flutter/material.dart';

class MuteButton extends StatelessWidget {
  const MuteButton({
    required this.isMuted,
    required this.onTap,
    super.key,
  });

  final bool isMuted;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Theme.of(context).disabledColor,
          border: Border.all(
            color: Theme.of(context).colorScheme.primary,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(
            height: 80,
            child: Center(
              child: isMuted
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: <Widget>[
                          LinearProgressIndicator(
                            minHeight: 32,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(12),
                            ),
                            valueColor: AlwaysStoppedAnimation<Color?>(
                              Theme.of(context).colorScheme.primary,
                            ),
                            backgroundColor: Theme.of(context).disabledColor,
                          ),
                          Text(
                            'MUTE',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    )
                  : Text(
                      'MUTE',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
