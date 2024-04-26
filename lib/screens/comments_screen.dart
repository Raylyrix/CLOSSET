import 'package:CLOSSET/models/comment.dart';
import 'package:CLOSSET/models/user.dart';
import 'package:CLOSSET/providers/user_provider.dart';
import 'package:CLOSSET/utils/colors.dart';
import 'package:CLOSSET/utils/utils.dart';
import 'package:CLOSSET/widgets/comment_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CommentsScreen extends StatefulWidget {
  final int postId;
  const CommentsScreen({Key? key, required this.postId}) : super(key: key);

  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final TextEditingController commentEditingController =
      TextEditingController();

  void postComment(int id, String name, String profilePic) async {
    try {
      if (commentEditingController.text.isEmpty) {
        return;
      }
      Comment.createComment(
        Comment(
            id: id,
            postID: widget.postId,
            userID: id,
            userName: name,
            userImage: profilePic,
            content: commentEditingController.text),
      );
      String res = 'success';

      if (res != 'success') {
        if (context.mounted) showSnackBar(context, res);
      }
      setState(() {
        commentEditingController.text = "";
      });
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).user;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: const Text(
          'Comments',
        ),
        centerTitle: false,
      ),
      body: FutureBuilder(
        future: Comment.getComments(widget.postId),
        builder: (context, AsyncSnapshot<List<Comment>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (ctx, index) => CommentCard(
              comment: snapshot.data![index],
            ),
          );
        },
      ),
      // text input
      bottomNavigationBar: SafeArea(
        child: Container(
          height: kToolbarHeight,
          margin:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          padding: const EdgeInsets.only(left: 16, right: 8),
          child: Row(
            children: [
              user.profile_image != ""
                  ? CircleAvatar(
                      backgroundImage: NetworkImage(user.profile_image),
                      radius: 18,
                    )
                  : const CircleAvatar(
                      backgroundColor: Colors.grey,
                      radius: 18,
                      child: Icon(
                        Icons.person,
                        color: Colors.white,
                      ),
                    ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 8),
                  child: TextField(
                    controller: commentEditingController,
                    decoration: InputDecoration(
                      hintText: 'Comment as ${user.name}',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () => postComment(
                  user.id,
                  user.name,
                  user.profile_image,
                ),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  child: const Text(
                    'Post',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
