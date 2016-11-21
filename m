From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH 00/16] Kernel lockdown
Date: Mon, 21 Nov 2016 19:53:07 +0000
Message-ID: <CAKv+Gu-6CpLK1fO_aRo77UGqXqnv4Wy0=beJNpkvovXvNmYF-w@mail.gmail.com>
References: <147933283664.19316.12454053022687659937.stgit@warthog.procyon.org.uk>
 <20161116222731.563fb85e@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20161116222731.563fb85e@lxorguk.ukuu.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: David Howells <dhowells@redhat.com>, keyrings@vger.kernel.org, Matthew Garrett <matthew.garrett@nebula.com>, linux-security-module <linux-security-module@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On 16 November 2016 at 23:27, One Thousand Gnomes
<gnomes@lxorguk.ukuu.org.uk> wrote:
> Whether it's a good idea aside
>
> You need to filter or lock down kernel module options because a lot of
> modules let you set the I/O port or similar (eg mmio) which means you can
> hack the entire machine with say the 8250 driver just by using it with an
> mmio of the right location to patch the secure state to zero just by
> getting the ability to write to the modules conf file.
>

This applies equally to the kernel command line, and given that we
cannot authenticate it, we should whitelist params that we know to be
safe, and filter out all others. A similar concern exists for the
device tree on ARM/arm64, and we already disable the DTB loader in the
UEFI stub if secure boot is enabled.

> Without that at least fixed I don't see the point in merging this. Either
> we don't do it (which given the level of security the current Linux
> kernel provides, and also all the golden key messups from elsewhere might
> be the honest approach), or at least try and do the job right.
>
> Less security is better than fake security. If you've got less security
> your take appropriate precautions. If you rely on fake security you don't.
>

In general, I think kernel hardening is an important topic, and this
series covers many cases where userland APIs can be subverted to
manipulate the state of the kernel in ways that weren't intended.
However, it would be naive to think that the series covers all such
cases, and I don't think that is what the authors intend to convey.
