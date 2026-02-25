class HelpCenterOption {
  final String title;
  final String description;
  final String icon;
  final Function()? onTap;

  HelpCenterOption({
    required this.title,
    required this.description,
    required this.icon,
    this.onTap,
  });
}
