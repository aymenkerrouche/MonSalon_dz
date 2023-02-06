// ignore_for_file: file_names

import 'package:flutter/material.dart';
import '../../../theme/colors.dart';
import 'components/sign_up_form.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  ScrollController? _scrollController;
  bool lastStatus = true;
  double height = 200;
  void _scrollListener() {
    if (isShrink != lastStatus) {
      setState(() {
        lastStatus = isShrink;
      });
    }
  }

  bool get isShrink {
    return _scrollController != null &&
        _scrollController!.hasClients &&
        _scrollController!.offset > (height - kToolbarHeight);
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController?.removeListener(_scrollListener);
    _scrollController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return NestedScrollView(
        //physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        controller: _scrollController,
        floatHeaderSlivers: false,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: SliverSafeArea(
                top: false,
                sliver: SliverAppBar(
                  expandedHeight: size.height * 0.25,
                  pinned: true,
                  backgroundColor: primary,
                  floating: false,
                  forceElevated: false,
                  elevation: 0,
                  title: AnimatedSwitcher(
                    key: const Key("show"),
                    duration: const Duration(milliseconds: 300),
                    child: isShrink
                        ? const Text(
                            "Profile",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Montserrat',
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.clip,
                          )
                        : const Text(
                            "",
                            key: Key("not"),
                          ),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    background: Image.asset("assets/images/salon1.jpg",fit: BoxFit.fill,)
                  ),
                ),
              ),
            )
          ];
        },
        body: Container(
          color: white,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: const SignUpForm(),
        ),
      );
  }
}
