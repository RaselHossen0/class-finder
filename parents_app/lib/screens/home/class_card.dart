import 'package:class_finder/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../Screens/chat/chatScreen.dart';
import '../../components/class_info.dart';
import '../../models/class.dart';
import '../../providers/chatProvider.dart';
import '../../providers/user_provider.dart';

class CookingClassCard extends ConsumerWidget {
  final ClassModel classModel;
  final VoidCallback onJoinTap;

  const CookingClassCard({
    Key? key,
    required this.classModel,
    required this.onJoinTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.read(userDetailsProvider);
    return InkWell(
      onTap: onJoinTap,
      child: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image container with overlays
            Stack(
              children: [
                // Background image
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                    image: DecorationImage(
                      image: NetworkImage(classModel.media.firstOrNull?.url ??
                          'https://imgmedia.lbb.in/media/2019/03/5c9213c8005a5f60d9912ac5_1553077192080.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Date chip
                Positioned(
                  top: 16,
                  right: 16,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      classModel.price.toString() + ' ₹',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                // Fork icon
                Positioned(
                  top: 16,
                  left: 16,
                  child: Container(
                    height: 40,
                    width: 40,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: Image.network(
                      classModel.category.logo ??
                          'https://www.shutterstock.com/image-vector/category-icon-flat-illustration-vector-600nw-2431883211.jpg',
                      errorBuilder: (context, error, stackTrace) =>
                          Image.asset(categoryIcon),
                    ),
                  ),
                ),
              ],
            ),
            // Content section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    classModel.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 20,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          classModel.location,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      Container(
                        // padding: const EdgeInsets.symmetric(
                        //   horizontal: 2,
                        //   vertical: 1,
                        // ),
                        decoration: BoxDecoration(
                          color: Colors.black12.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: IconButton(
                            onPressed: () async {
                              print('User: $user');
                              print('Class Owner: ${classModel.ClassOwnerId}');

                              final params = {
                                'userId': user!.id,
                                'classOwnerId': classModel.ClassOwnerId
                              };
                              final chatRoom = await ref
                                  .read(createChatProvider(params).future);

                              if (chatRoom != null) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ChatScreen(chatId: chatRoom),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text('Failed to create chat room')),
                                );
                              }

                              // Placeholder for chat navigation
                              // Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen()));
                            },
                            icon: Icon(Icons.message,
                                color: Colors.black, size: 20)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ClassInfoWidget(
                        classModel: classModel, showDistanceOnly: true),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
