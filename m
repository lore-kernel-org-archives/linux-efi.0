From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Problem with new X.509 is_hash_blacklisted() interface
Date: Sat, 27 May 2017 08:05:25 -0700
Message-ID: <1495897525.3458.7.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Added by

commit 436529562df2748fd9918f578205b22cf8ced277
Author: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Date:   Mon Apr 3 16:07:25 2017 +0100

    X.509: Allow X.509 certs to be blacklisted
 
Ironically it duplicates a UEFI bug we've been struggling with for a
while in the pkcs11 handlers:  namely if you have a blacklist based on
certificate hashes, an interface which only takes a hash cannot
definitively tell you if the certificate is on the blacklist or not
because the hash the cert is blacklisted by may be a different
algorithm from the hash you feed in to is_hash_blacklisted().  This
means that the only safe way to use the interface is to construct every
possible hash of the cert and feed them one at a time into
is_hash_blacklisted().  This makes it an almost unusable API.

I suggest you deprecate this interface immediately and introduce an
is_cert_blacklisted() one which takes a pointer to the TBS data.  Then
the implementation can loop over the blacklists, see the hash type and
construct the hash of the TBS data for comparison (caching the hashes
for efficiency).  That way you'll be assured of a definitive answer and
an easy API.

It might be reasonable to cc linux-efi on future kernel keyring stuff,
because some of the other issues may have also come up in the UEFI
keyrings.

James
