import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AlbumCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.width - 16,
        height: MediaQuery.of(context).size.height / 2,
        child: Card(
            elevation: 0,
            color: Theme.of(context).colorScheme.surfaceVariant,
            child: Column(
              children: [
                Expanded(
                  flex: 55,
                  child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Image.asset(
                          'assets/kids.jpg',
                          fit: BoxFit.fitWidth,
                        ),
                      )),
                ),
                Expanded(
                    flex: 45,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8, top: 8),
                              child: Text("KIDS SEE GHOST",
                                  maxLines: 1,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall),
                            ),
                            Padding(
                                padding:
                                    const EdgeInsets.only(right: 8, left: 8),
                                child: Text(
                                  "today",
                                  style: Theme.of(context).textTheme.bodyLarge,
                                  textAlign: TextAlign.right,
                                ))
                          ],
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Text(
                                "by KIDS SEE GHOST",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 8),
                              child: ActionChip(
                                avatar: Icon(Icons.music_note),
                                label: Text("Hip-Hop/Rap"),
                                onPressed: () {},
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: ActionChip(
                                avatar: SvgPicture.asset("assets/rym.svg"),
                                label: Text("3.89/5"),
                                onPressed: () {},
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8, top: 16, right: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton.filled(
                                  onPressed: () {},
                                  icon: const Icon(Icons.more_vert)),
                              // new Spacer(),
                              FilledButton.icon(
                                icon: SvgPicture.asset(
                                  "assets/spotify.svg",
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                  width: 18,
                                  height: 18,
                                ),
                                onPressed: () {},
                                label: const Text("Listen on Spotify"),
                              ),
                            ],
                          ),
                        )
                      ],
                    ))
              ],
            )));
  }
}
