From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] hash addresses printed with %p
Date: Thu, 30 Nov 2017 18:17:47 -0500
Message-ID: <CA+55aFwvbR+6e7YrZ3Q+sYzJsRikJEAi1YsA49CQjWgsa7KTWQ@mail.gmail.com>
References: <20171129045927.GA6217@eros> <CA+55aFzVy-SE9w1puPjgE1BxGje8oR3Ks9BDU7GXmvBYJfkCxw@mail.gmail.com>
 <20171129210848.GF6217@eros> <CA+55aFwjhjGZC9U68mo4hnnJXLWYxG3UYoz-=SwNfO-3N-Untg@mail.gmail.com>
 <CA+55aFwPXV0sXb+edcQc4epz0pWustZgJsoq95=a3OEDxynq7g@mail.gmail.com>
 <20171130163235.GA27849@kroah.com> <20171130171036.GB31817@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171130171036.GB31817@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Tobin C. Harding" <me@tobin.cc>, Matt Fleming <matt@codeblueprint.co.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, LKML <linux-kernel@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On Thu, Nov 30, 2017 at 12:10 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> So changing it to use __ATTR() should fix this remaning leakage up.
> That is if we even really need to export these values at all.  What does
> userspace do with them?  Shouldn't they just be in debugfs instead?

So what I find distasteful here is how sysfs has these "helper" macros
that are clearly designed to over-share.

The __ATTR macro is a lot  more complicated to use than the
__ATTR_RO/WO/RW macros, but those macros end up giving everybody read
access (ok, not the WO one)

So honestly, I think the "helper" functions should be deprecated
simply because they basically encourage people to make everything
world-readable.

Which is why most of sysfs is world-readable, whether it makes sense or not.

It would have been better had they just taken the actual mode, I suspect.

(And it would be better yet if the code didn't use that disgusting
S_IRUGO, which pretty much everybody has to think about to figure out
it's 0444)

               Linus
