From: Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH v3 2/7] x86, boot: Move ZO to end of buffer
Date: Tue, 10 Mar 2015 08:11:03 -0700
Message-ID: <CAE9FiQVPLUPWPhZ4yROTECVKeLTNUMXOURoYx0sG_SGPfCNGQw@mail.gmail.com>
References: <1425766041-6551-1-git-send-email-yinghai@kernel.org>
	<1425766041-6551-3-git-send-email-yinghai@kernel.org>
	<20150310080024.GB3535@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150310080024.GB3535@pd.tnic>
Sender: linux-kernel-owner@vger.kernel.org
To: Borislav Petkov <bp@suse.de>
Cc: Matt Fleming <matt.fleming@intel.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Kees Cook <keescook@chromium.org>, Baoquan He <bhe@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Jiri Kosina <jkosina@suse.cz>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On Tue, Mar 10, 2015 at 1:00 AM, Borislav Petkov <bp@suse.de> wrote:
> Final patch:
>
> ---
> From: Yinghai Lu <yinghai@kernel.org>
> Date: Sat, 7 Mar 2015 14:07:16 -0800
> Subject: [PATCH] x86/setup: Move compressed kernel to the end of the buffer

setup should only about arch/x86/boot/setup.ld related.

So please keep x86, boot.

Also stop using "compressed kernel" please, that is confusing.

Just use

ZO: arch/x86/boot/compressed/vmlinux
VO: vmlinux

Thanks

Yinghai
