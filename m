From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] hash addresses printed with %p
Date: Wed, 29 Nov 2017 13:36:25 -0800
Message-ID: <CA+55aFwPXV0sXb+edcQc4epz0pWustZgJsoq95=a3OEDxynq7g@mail.gmail.com>
References: <20171129045927.GA6217@eros> <CA+55aFzVy-SE9w1puPjgE1BxGje8oR3Ks9BDU7GXmvBYJfkCxw@mail.gmail.com>
 <20171129210848.GF6217@eros> <CA+55aFwjhjGZC9U68mo4hnnJXLWYxG3UYoz-=SwNfO-3N-Untg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFwjhjGZC9U68mo4hnnJXLWYxG3UYoz-=SwNfO-3N-Untg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Tobin C. Harding" <me@tobin.cc>, Matt Fleming <matt@codeblueprint.co.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On Wed, Nov 29, 2017 at 1:14 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Not because %pK itself changed, but because the semantics of %p did.
> The baseline moved, and the "safe" version did not.

Btw, that baseline for me is now that I can do

  ./scripts/leaking_addresses.pl | wc -l
  18

and of those 18 hits, six are false positives (looks like bitmaps in
the uevent keys).

The remaining 12 are from the EFI runtime map files
(/sys/firmware/efi/runtime-map/*). They should presumably not be
world-readable, but sadly the kset_create_and_add() helper seems to do
that by default.

I think the sysfs code makes it insanely too easy to make things
world-readable. You try to be careful, and mark things read-only etc,
but __ATTR_RO() jkust means S_IRUGO, which means world-readable.

There seems to be no convenient model for kobjects having better
permissions. Greg?

              Linus
