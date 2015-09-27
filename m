From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH 1/2] x86/efi: Map EFI memmap entries in-order at runtime
Date: Sun, 27 Sep 2015 09:30:48 -0700
Message-ID: <CALCETrUA6k-oHzuWA54VzEA1v63b5--JPCCuBoOxLisOtjUn+g@mail.gmail.com>
References: <1443218539-7610-1-git-send-email-matt@codeblueprint.co.uk>
 <1443218539-7610-2-git-send-email-matt@codeblueprint.co.uk>
 <20150926055643.GA25877@gmail.com> <CALCETrUeGAedCKcSCvedyooamr6-tyfb3-b3uYDZG+k3Q_v9rw@mail.gmail.com>
 <E40EBF14-FD9E-49C0-A7FB-951958F72F79@zytor.com> <CAKv+Gu8i4KuXYQZA5noTomj6-chZcuuDEQubOJznyP1DR=+VTw@mail.gmail.com>
 <0568D1D7-B6AA-437C-ADCE-A86D7A2E4722@zytor.com> <20150926195755.GC3144@codeblueprint.co.uk>
 <BFDFFBC6-C6CA-4035-8E29-C7220533A787@linaro.org> <F1F37F57-7D03-4FC2-955E-7E8C82540A24@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <F1F37F57-7D03-4FC2-955E-7E8C82540A24@zytor.com>
Sender: stable-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Denys Vlasenko <dvlasenk@redhat.com>, Leif Lindholm <leif.lindholm@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>, stable <stable@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Matthew Garrett <mjg59@srcf.ucam.org>, Ingo Molnar <mingo@kernel.org>, Brian Gerst <brgerst@gmail.com>, Dave Young <dyoung@redhat.com>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Linus Torvalds <torvalds@linux-foundation.org>, Peter Jones <pjones@redhat.com>, Matt Fleming <matt@codeblueprint.co.uk>, Matt Fleming <matt.fleming@intel.com>, Borislav Petkov <bp@suse.de>, "Lee, Chun-Yi" <jlee@suse.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, James Bottomley <JBottomley@odin.com>
List-Id: linux-efi@vger.kernel.org

On Sep 26, 2015 1:19 PM, "H. Peter Anvin" <hpa@zytor.com> wrote:
>
> Sadly a lot of firmware is known to fail in that configuration :(  That was very much our guest choice.
>

Why can't we map everything completely 1:1 (VA = PA) and call the
setVA thing but pass it literally the identity.

Firmwares that need it to be called will work, and firmwares that fail
to update all offsets will be fine because there's nothing to update.

--Andy
