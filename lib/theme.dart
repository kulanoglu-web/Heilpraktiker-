import 'dart:math' as math;

import 'package:flutter/material.dart';

const kGood = Color(0xFF2E9E6B);
const kBad = Color(0xFFD64545);
const kBrand = Color(0xFF2F5D8A);
const kBrandDark = Color(0xFF16324F);
const kAccent = Color(0xFF19A7A0);

/// Farbe mit Deckkraft 0..1 (ohne veraltete withOpacity-API).
Color tint(Color c, double opacity) =>
    c.withAlpha((opacity * 255).round().clamp(0, 255));

bool isDark(BuildContext context) =>
    Theme.of(context).brightness == Brightness.dark;

ThemeData buildTheme(Brightness b) {
  final dark = b == Brightness.dark;
  final scheme = ColorScheme.fromSeed(seedColor: kBrand, brightness: b);
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor:
        dark ? const Color(0xFF0E1620) : const Color(0xFFF2F5F9),
    visualDensity: VisualDensity.standard,
  );
}

/// Symbol und Farbe je Themenbereich.
class TopicStyle {
  final IconData icon;
  final Color color;
  const TopicStyle(this.icon, this.color);
}

TopicStyle topicStyle(String topic) {
  switch (topic) {
    case 'Grundlagen':
      return const TopicStyle(Icons.menu_book_rounded, Color(0xFF5C6BC0));
    case 'Diagnostik & Therapie':
      return const TopicStyle(Icons.healing_rounded, Color(0xFF00897B));
    case 'Affekt & Angst':
      return const TopicStyle(Icons.mood_bad_rounded, Color(0xFF7E57C2));
    case 'Psychosen':
      return const TopicStyle(Icons.blur_on_rounded, Color(0xFFE5733F));
    case 'Sucht':
      return const TopicStyle(Icons.local_bar_rounded, Color(0xFFC0392B));
    case 'Essstörungen':
      return const TopicStyle(Icons.restaurant_rounded, Color(0xFFE08A1E));
    case 'Persönlichkeit':
      return const TopicStyle(Icons.theater_comedy_rounded, Color(0xFFAD4C8F));
    case 'Trauma & Belastung':
      return const TopicStyle(Icons.flash_on_rounded, Color(0xFFD1495B));
    case 'Somatoform & Dissoziativ':
      return const TopicStyle(
          Icons.accessibility_new_rounded, Color(0xFF3F8EBF));
    case 'Organisch':
      return const TopicStyle(Icons.memory_rounded, Color(0xFF6B8E23));
    case 'Kinder & Jugend':
      return const TopicStyle(Icons.child_care_rounded, Color(0xFF2E9E6B));
    case 'Recht & Praxis':
      return const TopicStyle(Icons.gavel_rounded, Color(0xFF8D6E4B));
    case 'Weitere Störungen':
      return const TopicStyle(Icons.category_rounded, Color(0xFF607D8B));
    default:
      return const TopicStyle(Icons.help_outline_rounded, Color(0xFF78909C));
  }
}

LinearGradient brandGradient([Color a = kBrandDark, Color b = kBrand]) =>
    LinearGradient(
      colors: [a, b],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

LinearGradient colorGradient(Color c) => LinearGradient(
      colors: [Color.lerp(c, Colors.black, 0.18)!, Color.lerp(c, Colors.white, 0.12)!],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

/// Weiche Karte mit Schatten, optionalem Verlauf und Tipp-Effekt.
class SoftCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? color;
  final Gradient? gradient;
  final Color? borderColor;
  final double radius;
  final VoidCallback? onTap;

  const SoftCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.color,
    this.gradient,
    this.borderColor,
    this.radius = 20,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final dark = isDark(context);
    final shape = BorderRadius.circular(radius);
    return Container(
      decoration: BoxDecoration(
        color: gradient == null
            ? (color ?? (dark ? const Color(0xFF17222F) : Colors.white))
            : null,
        gradient: gradient,
        borderRadius: shape,
        border: Border.all(
          color: borderColor ??
              (dark ? const Color(0xFF263547) : const Color(0xFFE3E9F0)),
        ),
        boxShadow: dark
            ? null
            : [
                BoxShadow(
                  color: tint(const Color(0xFF102A43), 0.08),
                  blurRadius: 18,
                  offset: const Offset(0, 6),
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: shape,
        child: InkWell(
          borderRadius: shape,
          onTap: onTap,
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}

/// Kleines Etikett mit Symbol (z. B. Themenbereich).
class TopicChip extends StatelessWidget {
  final String topic;
  final bool selected;
  final VoidCallback? onTap;
  final String? suffix;

  const TopicChip({
    super.key,
    required this.topic,
    this.selected = true,
    this.onTap,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    final s = topicStyle(topic);
    final label = suffix == null ? topic : '$topic · $suffix';
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            color: selected ? s.color : tint(s.color, 0.12),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(s.icon, size: 16, color: selected ? Colors.white : s.color),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: selected ? Colors.white : s.color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Animierter Fortschrittsring.
class ScoreRing extends StatelessWidget {
  final double value;
  final double size;
  final double stroke;
  final Color color;
  final Color? track;
  final Widget? center;

  const ScoreRing({
    super.key,
    required this.value,
    this.size = 120,
    this.stroke = 12,
    this.color = Colors.white,
    this.track,
    this.center,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: value.clamp(0.0, 1.0)),
      duration: const Duration(milliseconds: 900),
      curve: Curves.easeOutCubic,
      builder: (context, v, _) => SizedBox(
        width: size,
        height: size,
        child: CustomPaint(
          painter: _RingPainter(v, color, track ?? tint(color, 0.22), stroke),
          child: Center(child: center),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double value;
  final Color color;
  final Color track;
  final double stroke;
  _RingPainter(this.value, this.color, this.track, this.stroke);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset(stroke / 2, stroke / 2) &
        Size(size.width - stroke, size.height - stroke);
    final base = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(rect, 0, math.pi * 2, false, base..color = track);
    canvas.drawArc(
        rect, -math.pi / 2, math.pi * 2 * value, false, base..color = color);
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.value != value || old.color != color || old.track != track;
}

/// Horizontaler Balken mit Beschriftung.
class BarRow extends StatelessWidget {
  final String label;
  final double value;
  final Color color;
  final String trailing;
  const BarRow({
    super.key,
    required this.label,
    required this.value,
    required this.color,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(label,
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w600)),
              ),
              Text(trailing,
                  style: const TextStyle(
                      fontSize: 12.5, fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: value.clamp(0.0, 1.0)),
              duration: const Duration(milliseconds: 700),
              curve: Curves.easeOutCubic,
              builder: (context, v, _) => LinearProgressIndicator(
                value: v,
                minHeight: 8,
                color: color,
                backgroundColor: tint(color, 0.15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

PreferredSizeWidget plainAppBar(String title, {List<Widget>? actions}) =>
    AppBar(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      actions: actions,
    );
