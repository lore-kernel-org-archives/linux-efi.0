From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: [PATCH] x86, boot: Allow 64bit EFI kernel to be loaded above 4G
Date: Thu, 12 Feb 2015 14:59:42 +0000
Message-ID: <20150212145942.GE4665@codeblueprint.co.uk>
References: <1423015400-12629-1-git-send-email-yinghai@kernel.org>
 <20150209182742.GQ6461@codeblueprint.co.uk>
 <CAE9FiQUFO4yfEVgGZ9U0Q-RaokFor1gMbKJ7As2vvqGVkqrDbw@mail.gmail.com>
 <20150211155524.GC4665@codeblueprint.co.uk>
 <20150211162958.GA18062@fenchurch.internal.datastacks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150211162958.GA18062@fenchurch.internal.datastacks.com>
Sender: linux-doc-owner@vger.kernel.org
To: Peter Jones <pjones@redhat.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Junjie Mao <eternal.n08@gmail.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Matthew Garrett <mjg59@srcf.ucam.org>
List-Id: linux-efi@vger.kernel.org

On Wed, 11 Feb, at 11:29:58AM, Peter Jones wrote:
> 
> From grub's point of view I'm not sure why we'd care - the pages kernel
> and initramfs land in are both from the Boot Services allocator, so if the
> machine doesn't support high addresses, they won't be there.

It's not that some implementations don't "support" higher addresses,
it's that the EFI_FILE_PROTOCOL is buggy and it corrupts the memory when
reading into it; you can allocate it just fine. At least, that's what I
remember from the limited investigation I performed.

But since grub doesn't use EFI_FILE_PROTOCOL, we should be cool.

-- 
Matt Fleming, Intel Open Source Technology Center
