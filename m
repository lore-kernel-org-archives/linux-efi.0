From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 08a/30] kexec_file: split KEXEC_VERIFY_SIG into KEXEC_SIG and KEXEC_SIG_FORCE
Date: Wed, 17 Jan 2018 16:34:24 +0000
Message-ID: <24618.1516206864@warthog.procyon.org.uk>
References: <20180116193936.oiycvwlk5xy3gm77@dwarf.suse.cz> <20180111120157.23qceywzi6omvvkb@dwarf.suse.cz> <151024863544.28329.2436580122759221600.stgit@warthog.procyon.org.uk> <151024869793.28329.4817577607302613028.stgit@warthog.procyon.org.uk> <20180111115915.dejachty3l7fwpmf@dwarf.suse.cz> <4582.1516120311@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180116193936.oiycvwlk5xy3gm77@dwarf.suse.cz>
Content-ID: <24617.1516206864.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Jiri Bohac <jbohac@suse.cz>
Cc: dhowells@redhat.com, linux-security-module@vger.kernel.org, gnomes@lxorguk.ukuu.org.uk, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, jforbes@redhat.com, Chun-Yi Lee <joeyli.kernel@gmail.com>
List-Id: linux-efi@vger.kernel.org

Jiri Bohac <jbohac@suse.cz> wrote:

> > If sig_err is -EKEYREJECTED, -EKEYEXPIRED or -EKEYREVOKED then it must fail,
> > even if the signature check isn't forced.
> 
> It wasn't my intention to fail in these cases. What additional
> security does this bring? If simply stripping an invalid
> signature from the image before loading will make it pass, why
> should the image with an invalid signature be rejected?

If there is a signature, then if we're checking signatures, in my opinion we
should check it - and fail if the signature can't be parsed, is revoked, we
have a key and the signature doesn't match - or even if we run out of memory.

The cases for which enforcement is required are when (a) there is no
signature, (b) we don't support the algorithms used, or (c) we don't have a
key.

If we're going to completely discard the result, why do your patches even
bother to check the signature at all?

David
