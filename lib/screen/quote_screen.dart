import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Provider/darkTheme_provider.dart';
import '../Provider/quote_provider.dart';
import 'history_screen.dart';

class QuoteScreen extends StatefulWidget {
  const QuoteScreen({super.key});

  @override
  State<QuoteScreen> createState() => _QuoteScreenState();
}

class _QuoteScreenState extends State<QuoteScreen> {
  Future<void> _launchLinkedIn() async {
    final Uri url = Uri.parse('https://www.linkedin.com/in/adnan-saifi-a6ba01292/');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      debugPrint('Could not launch $url');
    }
  }


  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<QuoteProvider>(context);
    final themeChanger = Provider.of<darkThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quotes',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
                themeChanger.isDark ? Icons.light_mode : Icons.dark_mode,
                color: themeChanger.isDark ? Colors.white : Colors.black,
                size: 27,
              ),
            onPressed: () {
              themeChanger.setTheme();
            },

          ),
        ],
      ),
      body: Center(
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (provider.loading)
                  const CircularProgressIndicator()
                else if (provider.quote == null)
                  Text("Press the button for new Quotes!")
                else
                Card(
                  elevation: 10,
                  child: Container(
                    color: Colors.white24,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 15),
                        Text(
                          '"${provider.quote!.content}"',
                          style: const TextStyle(
                            fontSize: 20,
                            fontStyle: FontStyle.italic,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 15),
                        Text(
                          '- ${provider.quote!.author}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 18),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: const [
                            LikeButton(),       // ❤️ animated like
                            SizedBox(width: 16),
                            SaveButton(),       // 🔖 animated save
                          ],
                        ),
                        SizedBox(height: 20,)
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                ElevatedButton(onPressed: (){
                  provider.getRandomQuote();
                  provider.resetStates();
                }, style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                    ),
                    child: Text('New Quote')),
              ],
            ),
          ),
        ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          '</> Mohd Adnan Saifi',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: themeChanger.isDark ? Colors.white70 : Colors.black54,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

}





/// Common animation duration/curves
const _animDuration = Duration(milliseconds: 220);
const _popCurve = Curves.easeOutBack;     // thoda "pop" feel
const _slideCurve = Curves.easeOutCubic;  // soft slide

/// ---------- LIKE BUTTON ----------
/// Rebuilds only when `isLiked` changes. Pop-in animation on toggle.
class LikeButton extends StatelessWidget {
  const LikeButton({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<darkThemeProvider>(context);
    return Selector<QuoteProvider, bool>(
      selector: (_, p) => p.isLiked,
      builder: (_, isLiked, __) {
        return InkWell(
          borderRadius: BorderRadius.circular(28),
          onTap: () => context.read<QuoteProvider>().toggleLike(),
          onDoubleTap: () => context.read<QuoteProvider>().toggleLike(),
          child: AnimatedSwitcher(
            duration: _animDuration,
            transitionBuilder: (child, anim) => ScaleTransition(
              scale: CurvedAnimation(parent: anim, curve: _popCurve),
              child: child,
            ),
            child: Icon(
              isLiked ? Icons.favorite : Icons.favorite_border,
              key: ValueKey<bool>(isLiked),
              size: 28,
              color: isLiked
                  ? Colors.red
                  : themeProvider.isDark
                  ? Colors.white
                  : Colors.black,

            ),
          ),
        );
      },
    );
  }
}

/// ---------- SAVE BUTTON ----------
/// Rebuilds only when `isSaved` changes. Slide/flip-ish feel on toggle.
class SaveButton extends StatelessWidget {
  const SaveButton({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<darkThemeProvider>(context);
    return Selector<QuoteProvider, bool>(
      selector: (_, p) => p.isSaved,
      builder: (_, isSaved, __) {
        return InkWell(
          borderRadius: BorderRadius.circular(28),
          onTap: () => context.read<QuoteProvider>().toggleSave(),
          child: AnimatedSwitcher(
            duration: _animDuration,
            transitionBuilder: (child, anim) {
              // thoda sa slide + fade for a subtle motion
              final slide = Tween<Offset>(
                begin: const Offset(0, .20),
                end: Offset.zero,
              ).animate(CurvedAnimation(parent: anim, curve: _slideCurve));

              return SlideTransition(
                position: slide,
                child: FadeTransition(opacity: anim, child: child),
              );
            },
            child: Icon(
              isSaved ? Icons.bookmark : Icons.bookmark_border,
              key: ValueKey<bool>(isSaved),
              size: 28,
              // Instagram-style: filled bookmark bhi grey rahta hai
              color: provider.isDark? Colors.white:Colors.black
            ),
          ),
        );
      },
    );
  }
}