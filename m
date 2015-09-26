From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: [PATCH 1/2] x86/efi: Map EFI memmap entries in-order at runtime
Date: Sat, 26 Sep 2015 20:57:55 +0100
Message-ID: <20150926195755.GC3144@codeblueprint.co.uk>
References: <1443218539-7610-1-git-send-email-matt@codeblueprint.co.uk>
 <1443218539-7610-2-git-send-email-matt@codeblueprint.co.uk>
 <20150926055643.GA25877@gmail.com>
 <CALCETrUeGAedCKcSCvedyooamr6-tyfb3-b3uYDZG+k3Q_v9rw@mail.gmail.com>
 <E40EBF14-FD9E-49C0-A7FB-951958F72F79@zytor.com>
 <CAKv+Gu8i4KuXYQZA5noTomj6-chZcuuDEQubOJznyP1DR=+VTw@mail.gmail.com>
 <0568D1D7-B6AA-437C-ADCE-A86D7A2E4722@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <0568D1D7-B6AA-437C-ADCE-A86D7A2E4722@zytor.com>
Sender: stable-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Matt Fleming <matt.fleming@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "Lee, Chun-Yi" <jlee@suse.com>, Borislav Petkov <bp@suse.de>, Leif Lindholm <leif.lindholm@linaro.org>, Peter Jones <pjones@redhat.com>, James Bottomley <JBottomley@odin.com>, Matthew Garrett <mjg59@srcf.ucam.org>, Dave Young <dyoung@redhat.com>, stable <stable@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Borislav Petkov <bp@alien8.de>, Andy Lutomirski <luto@kernel.org>, Denys Vlasenko <dvlasenk@redhat.com>, Brian Gerst <brgerst@gmail.com>, Andrew Morton <akpm@linux-foundation.org>
List-Id: linux-efi@vger.kernel.org

On Sat, 26 Sep, at 12:49:26PM, H. Peter Anvin wrote:
>
> It is still a hack unless all relative offsets are preserved.  That
> is actually simpler, even: no sorting necessary.

Unless I'm missing something, preserving relative offsets is exactly
what we do today, modulo PMD_SIZE gaps.

-- 
Matt Fleming, Intel Open Source Technology Center
