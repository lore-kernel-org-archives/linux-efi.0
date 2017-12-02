From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [GIT PULL] hash addresses printed with %p
Date: Sat, 2 Dec 2017 08:51:52 +0000
Message-ID: <CAKv+Gu-fHg44tgEV1+EjA+mm_DreMgiZc0nTp3QcvNSfX1Pv1A@mail.gmail.com>
References: <20171129045927.GA6217@eros> <CA+55aFzVy-SE9w1puPjgE1BxGje8oR3Ks9BDU7GXmvBYJfkCxw@mail.gmail.com>
 <20171129210848.GF6217@eros> <CA+55aFwjhjGZC9U68mo4hnnJXLWYxG3UYoz-=SwNfO-3N-Untg@mail.gmail.com>
 <CA+55aFwPXV0sXb+edcQc4epz0pWustZgJsoq95=a3OEDxynq7g@mail.gmail.com>
 <20171130163235.GA27849@kroah.com> <20171130171036.GB31817@kroah.com>
 <CAKv+Gu_KF+BzFGaqYo1ZZAj9j+HkUogAksDFAkBDELU7m1XcPw@mail.gmail.com>
 <20171201094846.GE9353@kroah.com> <CAKv+Gu-YyuE-Hs4MVPWfS8Exx0S6qo5sgV2VdO0MP5wEXSrM1Q@mail.gmail.com>
 <20171201153444.GA17867@kroah.com> <CAGXu5j+DhUuucgjezvKNqDGRKq8Wp3L+XnO4DCb6BvJ5rOx7dw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAGXu5j+DhUuucgjezvKNqDGRKq8Wp3L+XnO4DCb6BvJ5rOx7dw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, "Tobin C. Harding" <me@tobin.cc>, Matt Fleming <matt@codeblueprint.co.uk>, LKML <linux-kernel@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On 1 December 2017 at 16:33, Kees Cook <keescook@chromium.org> wrote:
> On Fri, Dec 1, 2017 at 7:34 AM, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
>
>> And isn't there a specific %p modifier you should use for a kernel
>> pointer.  I've lost the thread here for what should, or should not, be
>> done for kernel pointers these days based on the long email discussion.
>
> Current implementation to bypass the hashing is %px. (Though perhaps
> all %px usage should include a comment with a justification?)
>

In this case, we're always dealing with u64 types regardless of the
pointer size and physical address size. So I am leaning towards
retaining the %llx, and only updating the sysfs node permissions.
