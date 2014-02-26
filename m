From: Kees Cook <keescook@chromium.org>
Subject: Re: Trusted kernel patchset for Secure Boot lockdown
Date: Wed, 26 Feb 2014 13:11:25 -0800
Message-ID: <CAGXu5j+b49grru-=DTRC0wx5LTOHN_jKL0Q++uW0Mzy+BxDf4w@mail.gmail.com>
References: <1393445473-15068-1-git-send-email-matthew.garrett@nebula.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1393445473-15068-1-git-send-email-matthew.garrett@nebula.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Greg KH <gregkh@linuxfoundation.org>, "H. Peter Anvin" <hpa@zytor.com>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, James Morris <jmorris@namei.org>, linux-security-module <linux-security-module@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On Wed, Feb 26, 2014 at 12:11 PM, Matthew Garrett
<matthew.garrett@nebula.com> wrote:
> The conclusion we came to at Plumbers was that this patchset was basically
> fine but that Linus hated the name "securelevel" more than I hate pickled
> herring, so after thinking about this for a few months I've come up with
> "Trusted Kernel". This flag indicates that the kernel is, via some
> external mechanism, trusted and should behave that way. If firmware has
> some way to verify the kernel, it can pass that information on. If userspace
> has some way to verify the kernel, it can set the flag itself. However,
> userspace should not attempt to use the flag as a means to verify that the
> kernel was trusted - untrusted userspace could have set it on an untrusted
> kernel, but by the same metric an untrusted kernel could just set it itself.
>
> If people object to this name then I swear to god that I will open a poll
> on Phoronix to decide the next attempt and you will like that even less.

For the Chrome OS use-case, it might be better described as "untrusted
userspace", but that seems unfriendly. :) The "trusted kernel" name
seems fine to me.

-Kees

-- 
Kees Cook
Chrome OS Security
