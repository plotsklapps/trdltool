import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:signals/signals_flutter.dart';
import 'package:trdltool/signals/themefont_signal.dart';
import 'package:trdltool/theme/flex_theme.dart';

class ThemeFontCarousel extends StatelessWidget {
  const ThemeFontCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> fontNames = sThemeFontList.value;
    final String selectedFont = sThemeFont.watch(context);

    return SizedBox(
      height: 140,
      child: CarouselView(
        itemExtent: 100,
        shrinkExtent: 100,
        onTap: (int index) {
          // Update the sThemeFont Signal.
          sThemeFont.value = fontNames[index];
        },
        children: <Widget>[
          for (final String fontKey in fontNames)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              decoration: BoxDecoration(
                color: cThemeData.watch(context).colorScheme.surfaceDim,
                border: Border.all(
                  color: fontKey == selectedFont
                      ? cThemeData.watch(context).colorScheme.primary
                      : Colors.transparent,
                  width: 4,
                ),
                borderRadius: BorderRadius.circular(28),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Center(
                      child: Builder(
                        builder: (context) {
                          final color = cThemeData
                              .watch(context)
                              .colorScheme
                              .onSurface;
                          TextStyle previewStyle;
                          switch (fontKey) {
                            case 'openSans':
                              previewStyle = GoogleFonts.openSans(
                                fontSize: 32,
                                color: color,
                              );
                              break;
                            case 'roboto':
                              previewStyle = GoogleFonts.roboto(
                                fontSize: 32,
                                color: color,
                              );
                              break;
                            case 'lato':
                              previewStyle = GoogleFonts.lato(
                                fontSize: 32,
                                color: color,
                              );
                              break;
                            case 'montserrat':
                              previewStyle = GoogleFonts.montserrat(
                                fontSize: 32,
                                color: color,
                              );
                              break;
                            case 'poppins':
                              previewStyle = GoogleFonts.poppins(
                                fontSize: 32,
                                color: color,
                              );
                              break;
                            case 'raleway':
                              previewStyle = GoogleFonts.raleway(
                                fontSize: 32,
                                color: color,
                              );
                              break;
                            case 'merriweather':
                              previewStyle = GoogleFonts.merriweather(
                                fontSize: 32,
                                color: color,
                              );
                              break;
                            case 'nunito':
                              previewStyle = GoogleFonts.nunito(
                                fontSize: 32,
                                color: color,
                              );
                              break;
                            case 'oswald':
                              previewStyle = GoogleFonts.oswald(
                                fontSize: 32,
                                color: color,
                              );
                              break;
                            case 'playfairDisplay':
                              previewStyle = GoogleFonts.playfairDisplay(
                                fontSize: 32,
                                color: color,
                              );
                              break;
                            case 'robotoSlab':
                              previewStyle = GoogleFonts.robotoSlab(
                                fontSize: 32,
                                color: color,
                              );
                              break;
                            case 'bebasNeue':
                              previewStyle = GoogleFonts.bebasNeue(
                                fontSize: 32,
                                color: color,
                              );
                              break;
                            case 'teko':
                              previewStyle = GoogleFonts.teko(
                                fontSize: 32,
                                color: color,
                              );
                              break;
                            case 'dancingScript':
                              previewStyle = GoogleFonts.dancingScript(
                                fontSize: 32,
                                color: color,
                              );
                              break;
                            case 'quicksand':
                              previewStyle = GoogleFonts.quicksand(
                                fontSize: 32,
                                color: color,
                              );
                              break;
                            case 'rubik':
                              previewStyle = GoogleFonts.rubik(
                                fontSize: 32,
                                color: color,
                              );
                              break;
                            case 'firaSans':
                              previewStyle = GoogleFonts.firaSans(
                                fontSize: 32,
                                color: color,
                              );
                              break;
                            case 'karla':
                              previewStyle = GoogleFonts.karla(
                                fontSize: 32,
                                color: color,
                              );
                              break;
                            case 'inconsolata':
                              previewStyle = GoogleFonts.inconsolata(
                                fontSize: 32,
                                color: color,
                              );
                              break;
                            case 'cinzel':
                              previewStyle = GoogleFonts.cinzel(
                                fontSize: 32,
                                color: color,
                              );
                              break;
                            case 'comfortaa':
                              previewStyle = GoogleFonts.comfortaa(
                                fontSize: 32,
                                color: color,
                              );
                              break;
                            case 'orbitron':
                              previewStyle = GoogleFonts.orbitron(
                                fontSize: 32,
                                color: color,
                              );
                              break;
                            case 'ptSerif':
                              previewStyle = GoogleFonts.ptSerif(
                                fontSize: 32,
                                color: color,
                              );
                              break;
                            case 'ubuntu':
                              previewStyle = GoogleFonts.ubuntu(
                                fontSize: 32,
                                color: color,
                              );
                              break;
                            case 'heebo':
                              previewStyle = GoogleFonts.heebo(
                                fontSize: 32,
                                color: color,
                              );
                              break;
                            case 'hind':
                              previewStyle = GoogleFonts.hind(
                                fontSize: 32,
                                color: color,
                              );
                              break;
                            case 'josefinSans':
                              previewStyle = GoogleFonts.josefinSans(
                                fontSize: 32,
                                color: color,
                              );
                              break;
                            case 'zillaSlab':
                              previewStyle = GoogleFonts.zillaSlab(
                                fontSize: 32,
                                color: color,
                              );
                              break;
                            case 'spectral':
                              previewStyle = GoogleFonts.spectral(
                                fontSize: 32,
                                color: color,
                              );
                              break;
                            case 'kanit':
                              previewStyle = GoogleFonts.kanit(
                                fontSize: 32,
                                color: color,
                              );
                              break;
                            case 'assistant':
                              previewStyle = GoogleFonts.assistant(
                                fontSize: 32,
                                color: color,
                              );
                              break;
                            case 'blackOpsOne':
                              previewStyle = GoogleFonts.blackOpsOne(
                                fontSize: 32,
                                color: color,
                              );
                              break;
                            case 'baloo2':
                              previewStyle = GoogleFonts.baloo2(
                                fontSize: 32,
                                color: color,
                              );
                              break;
                            case 'cormorantGaramond':
                              previewStyle = GoogleFonts.cormorantGaramond(
                                fontSize: 32,
                                color: color,
                              );
                              break;
                            default:
                              previewStyle = GoogleFonts.openSans(
                                fontSize: 32,
                                color: color,
                              );
                          }
                          return Text('Abc', style: previewStyle);
                        },
                      ),
                    ),
                  ),
                  Text(
                    fontKey,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: fontKey == selectedFont
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: cThemeData.watch(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
