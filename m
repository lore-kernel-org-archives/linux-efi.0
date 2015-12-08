From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH 1/2] x86: Fix kernel panic when booting with XD disabled
 in uEFI firmware
Date: Tue, 8 Dec 2015 21:54:11 +0100
Message-ID: <20151208205411.GA16417@pd.tnic>
References: <20151204164057.GE2514@codeblueprint.co.uk>
 <17EC94B0A072C34B8DCF0D30AD16044A0288EFC7@BPXM09GP.gisp.nec.co.jp>
 <20151208122557.GA2518@codeblueprint.co.uk>
 <20151208141946.GD27180@pd.tnic>
 <CAGXu5jKF3fVc5rsU=+jRcoBGB+ZkeHjF6mmSeJN0SoP-MpFGow@mail.gmail.com>
 <19122B57-8052-4A92-801E-03CC84E66F06@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <19122B57-8052-4A92-801E-03CC84E66F06@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Kees Cook <keescook@chromium.org>, Matt Fleming <matt@codeblueprint.co.uk>, Kosuke Tatsukawa <tatsu@ab.jp.nec.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "x86@kernel.org" <x86@kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On Tue, Dec 08, 2015 at 12:39:14PM -0800, H. Peter Anvin wrote:
> Actually I think of it much more as a debug option - being able to
> mimic NX-unaware hardware and to track down problems in the field.

Considering it can be dangerous when exposed to the user, should we hide
it behind a "Kernel Hacking" .config option which is default-off?

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
