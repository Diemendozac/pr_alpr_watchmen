
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class VehicleListItem extends StatelessWidget {
  final String plate;
  final String brand;
  final int model;
  final String line;
  final bool owner;
  final VoidCallback? onMarkAsExited;

  const VehicleListItem({super.key,
    required this.plate,
    required this.brand,
    required this.model,
    required this.line,
    required this.owner,
    this.onMarkAsExited,
  });

  @override
  Widget build(BuildContext context) {

    Color onSurfaceColor = Theme
        .of(context)
        .colorScheme.onSurface;

    Color secondaryColor = Theme
        .of(context)
        .colorScheme.secondary;

    TextStyle titleStyle = Theme
        .of(context)
        .textTheme
        .titleSmall!;
    TextStyle subtitleStyle = Theme
        .of(context)
        .textTheme
        .titleSmall!
        .copyWith(fontSize: 14, color: onSurfaceColor);
    TextStyle dataStyle = Theme
        .of(context)
        .textTheme
        .titleSmall!
        .copyWith(fontSize: 14);
    //Text('Modelo: $model | Placa: $plate')
    return ListTile(
      title: Text('$brand $line', style: titleStyle.copyWith(color: secondaryColor)),
      subtitle: RichText(
        text: TextSpan(
            text: 'Modelo: ',
            style: subtitleStyle,
            children: <TextSpan>[
              TextSpan(
                  text: model.toString(),
                  style: dataStyle
              ),
              TextSpan(
                  text: ' | ',
                  style: titleStyle
              ),
              TextSpan(
                  text: 'Placa: ',
                  style: subtitleStyle
              ),
              TextSpan(
                  text: plate,
                  style: dataStyle
              )

            ]
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            colorFilter: ColorFilter.mode(onSurfaceColor, BlendMode.srcIn),
            alignment: Alignment.center,
            owner
                ? 'assets/images/user3.svg'
                : 'assets/images/confidence-user3.svg',
            width: 19,
            height: 19,
          ),
          IconButton(onPressed: () {}, icon: const Icon(Icons.exit_to_app))
        ],
      ),
    );
  }
}
