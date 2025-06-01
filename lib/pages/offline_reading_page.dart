import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:localnewsapp/providers/offline_reading_provider.dart';
import 'package:localnewsapp/dataAccess/model/document.dart';

class OfflineReadingPage extends StatelessWidget {
  const OfflineReadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        body: OfflineReadingContent(),
      ),
    );
  }
}

class OfflineReadingContent extends StatelessWidget {
  const OfflineReadingContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<OfflineReadingProvider>(
      builder: (context, provider, _) {
        return Column(
          children: [
            AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: const Text('Offline reading'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  tooltip: 'Delete all downloads',
                  onPressed: () async {
                    await provider.deleteAllDownloads();
                  },
                ),
              ],
            ),
            Expanded(
              child: Column(
                children: [
                  // Auto-download switch
                  SwitchListTile(
                    title: const Text('Auto-download on Wi-Fi'),
                    subtitle: const Text('Automatically download articles when connected to Wi-Fi'),
                    value: provider.isAutoDownloadEnabled,
                    onChanged: (bool value) async {
                      await provider.toggleAutoDownload(value);
                    },
                  ),
                  const Divider(),
                  // Download button
                  if (provider.isDownloading)
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 8),
                          Text('Downloading articles...'),
                        ],
                      ),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          await provider.downloadLatestArticles();
                        },
                        icon: const Icon(Icons.download),
                        label: const Text('Download latest articles'),
                      ),
                    ),
                  const Divider(),
                  // Downloaded articles list
                  Expanded(
                    child: provider.downloadedArticles.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.article_outlined,
                                  size: 64,
                                  color: Colors.grey[400],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No articles downloaded yet',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Download articles to read them offline',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            itemCount: provider.downloadedArticles.length,
                            itemBuilder: (context, index) {
                              final Document article = provider.downloadedArticles[index];
                              return ListTile(
                                leading: const Icon(Icons.article),
                                title: Text(
                                  article.title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: Text(
                                  article.documentType,
                                  style: const TextStyle(color: Colors.grey),
                                ),
                                trailing: const Icon(Icons.arrow_forward_ios),
                                onTap: () {
                                  // TODO: Navigate to article detail
                                },
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
