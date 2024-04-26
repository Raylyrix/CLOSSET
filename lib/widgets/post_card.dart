import 'package:CLOSSET/models/like.dart';
import 'package:CLOSSET/models/post.dart';
import 'package:CLOSSET/models/user.dart';
import 'package:CLOSSET/models/wishlist.dart';
import 'package:CLOSSET/providers/user_provider.dart';
import 'package:CLOSSET/providers/wishlists_provider.dart';
import 'package:CLOSSET/screens/comments_screen.dart';
import 'package:CLOSSET/utils/colors.dart';
import 'package:CLOSSET/utils/global_variable.dart';
import 'package:CLOSSET/utils/utils.dart';
import 'package:CLOSSET/widgets/like_animation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PostCard extends StatefulWidget {
  Post post;
  User user;
  List<Like> likes;
  PostCard({
    Key? key,
    required this.post,
    required this.user,
    required this.likes,
  }) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  int commentLen = 0;
  bool isLikeAnimating = false;
  int selfId = 0;
  @override
  void initState() {
    super.initState();

    fetchCommentLen();
  }

  @override
  void didChangeDependencies() {
    selfId = Provider.of<UserProvider>(context).user.id;
    super.didChangeDependencies();
  }

  fetchCommentLen() {}

  deletePost() {}

  @override
  Widget build(BuildContext context) {
    // final model.User user = Provider.of<UserProvider>(context).geser;
    final width = MediaQuery.of(context).size.width;

    return Container(
      // boundary needed for web
      decoration: BoxDecoration(
        border: Border.all(
          color: width > webScreenSize ? secondaryColor : mobileBackgroundColor,
        ),
        color: mobileBackgroundColor,
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      child: Column(
        children: [
          // HEADER SECTION OF THE POST
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 4,
              horizontal: 16,
            ).copyWith(right: 0),
            child: Row(
              children: <Widget>[
                widget.user.profile_image != ""
                    ? CircleAvatar(
                        radius: 16,
                        backgroundImage:
                            NetworkImage(widget.user.profile_image),
                      )
                    : const CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.grey,
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                        ),
                      ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 8,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.user.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                widget.user.id == selfId
                    ? IconButton(
                        onPressed: () {
                          showDialog(
                            useRootNavigator: false,
                            context: context,
                            builder: (context) {
                              return Dialog(
                                child: ListView(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    shrinkWrap: true,
                                    children: [
                                      'Delete',
                                    ]
                                        .map(
                                          (e) => InkWell(
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 12,
                                                        horizontal: 16),
                                                child: Text(e),
                                              ),
                                              onTap: () {
                                                deletePost();
                                                // remove the dialog box
                                                Navigator.of(context).pop();
                                              }),
                                        )
                                        .toList()),
                              );
                            },
                          );
                        },
                        icon: const Icon(Icons.more_vert),
                      )
                    : Container(),
              ],
            ),
          ),
          // IMAGE SECTION OF THE POST
          GestureDetector(
            onDoubleTap: () {
              Like.likeAPost(widget.post.id);
              setState(() {
                isLikeAnimating = true;
              });
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.width,
                  width: double.infinity,
                  child: Image.network(
                    widget.post.image,
                    fit: BoxFit.cover,
                  ),
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: isLikeAnimating ? 1 : 0,
                  child: LikeAnimation(
                    isAnimating: isLikeAnimating,
                    duration: const Duration(
                      milliseconds: 400,
                    ),
                    onEnd: () {
                      setState(() {
                        isLikeAnimating = false;
                      });
                    },
                    child: const Icon(
                      Icons.favorite,
                      color: Colors.white,
                      size: 100,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // LIKE, COMMENT SECTION OF THE POST
          Row(
            children: <Widget>[
              LikeAnimation(
                isAnimating:
                    widget.likes.any((element) => element.userID == selfId),
                smallLike: true,
                child: IconButton(
                    icon:
                        widget.likes.any((element) => element.userID == selfId)
                            ? const Icon(
                                Icons.favorite,
                                color: Colors.red,
                              )
                            : const Icon(
                                Icons.favorite_border,
                              ),
                    onPressed: () => {
                          widget.likes
                                  .any((element) => element.userID == selfId)
                              ? Like.disLike(widget.post.id)
                                  .then((value) => setState(() {
                                        widget.likes.removeWhere((element) =>
                                            element.userID == selfId);
                                      }))
                              : Like.likeAPost(widget.post.id)
                                  .then((value) => setState(() {
                                        widget.likes.add(Like(
                                          id: value.id,
                                          userID: selfId,
                                          postID: widget.post.id,
                                        ));
                                      }))
                        }),
              ),
              IconButton(
                icon: const Icon(
                  Icons.comment_outlined,
                ),
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CommentsScreen(
                      postId: widget.post.id,
                    ),
                  ),
                ),
              ),
              IconButton(
                  icon: const Icon(
                    Icons.send,
                  ),
                  onPressed: () {}),
              Expanded(
                  child: Align(
                      alignment: Alignment.bottomRight,
                      child: !Provider.of<WishlistsProvider>(context)
                              .isPostInWishlists(widget.post.id)
                          ? IconButton(
                              icon: const Icon(Icons.bookmark_border),
                              onPressed: () {
                                List<Wishlist> wishLists =
                                    Provider.of<WishlistsProvider>(context,
                                            listen: false)
                                        .wishlists;
                                TextEditingController controller =
                                    TextEditingController();
                                showModalBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      return Padding(
                                        padding:
                                            MediaQuery.of(context).viewInsets,
                                        child: SizedBox(
                                          height: 180,
                                          child: Column(
                                            children: [
                                              ListTile(
                                                title: const Text(
                                                    'Choose a wishlist'),
                                                onTap: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                              ListView(
                                                shrinkWrap: true,
                                                children: wishLists
                                                    .map((e) => ListTile(
                                                          title: Text(e.name),
                                                          onTap: () {
                                                            Provider.of<WishlistsProvider>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .addPost(
                                                                    widget.post
                                                                        .id,
                                                                    e.id);
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                        ))
                                                    .toList(),
                                              ),
                                              Row(
                                                children: [
                                                  Expanded(
                                                      child: TextField(
                                                    controller: controller,
                                                    decoration:
                                                        const InputDecoration(
                                                      hintText:
                                                          'Create a new wishlist',
                                                    ),
                                                  )),
                                                  ElevatedButton(
                                                      onPressed: () {
                                                        Provider.of<WishlistsProvider>(
                                                                context,
                                                                listen: false)
                                                            .addNewWishlist(
                                                                controller.text,
                                                                selfId);
                                                        Provider.of<WishlistsProvider>(
                                                                context,
                                                                listen: false)
                                                            .addPost(
                                                                widget.post.id,
                                                                Provider.of<WishlistsProvider>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                    .wishlists
                                                                    .last
                                                                    .id);
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: const Text(
                                                          'Create ')),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    });
                              })
                          : IconButton(
                              icon: const Icon(Icons.bookmark,
                                  color: Colors.blue),
                              onPressed: () {
                                Provider.of<WishlistsProvider>(context,
                                        listen: false)
                                    .removePost(widget.post.id);
                              },
                            )))
            ],
          ),
          //DESCRIPTION AND NUMBER OF COMMENTS
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  DefaultTextStyle(
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall!
                          .copyWith(fontWeight: FontWeight.w800),
                      child: Text(
                        '${widget.likes.length} likes',
                        style: Theme.of(context).textTheme.bodyMedium,
                      )),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(
                      top: 8,
                    ),
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(color: primaryColor),
                        children: [
                          TextSpan(
                            text: '${widget.user.name} ',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: ' ${widget.post.description}',
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Text(
                            'View all $commentLen comments',
                            style: const TextStyle(
                              fontSize: 16,
                              color: secondaryColor,
                            ),
                          ),
                        ),
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => CommentsScreen(
                              postId: widget.post.id,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Text(
                          dateToDayMonthYear(widget.post.time),
                          style: const TextStyle(
                            color: secondaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ))
        ],
      ),
    );
  }
}
