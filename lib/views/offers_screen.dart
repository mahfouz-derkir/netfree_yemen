import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../core/constants/app_data.dart';

class OffersScreen extends StatelessWidget {
  const OffersScreen({Key? key}) : super(key: key);

  void _handleOfferAction(BuildContext context, OfficialOffer offer) async {
    if (offer.isUrl) {
      final Uri url = Uri.parse(offer.codeOrUrl);
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      }
    } else {
      final Uri telUri = Uri.parse("tel:${Uri.encodeComponent(offer.codeOrUrl)}");
      if (await canLaunchUrl(telUri)) {
        await launchUrl(telUri);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('العروض والباقات الرسمية'),
          backgroundColor: Colors.purple.shade900,
        ),
        body: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: AppData.officialOffers.length,
          itemBuilder: (context, index) {
            final offer = AppData.officialOffers[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                title: Text(offer.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 6),
                    Text(offer.description),
                    const SizedBox(height: 4),
                    Text(offer.note, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                  ],
                ),
                trailing: ElevatedButton(
                  onPressed: () => _handleOfferAction(context, offer),
                  child: Text(offer.isUrl ? "فتح" : "طلب"),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
