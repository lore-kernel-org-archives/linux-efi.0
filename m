From: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH 1/2] x86/efi: Map EFI memmap entries in-order at runtime
Date: Mon, 28 Sep 2015 07:41:43 +0100
Message-ID: <20150928064143.GA7380@srcf.ucam.org>
References: <CALCETrUeGAedCKcSCvedyooamr6-tyfb3-b3uYDZG+k3Q_v9rw@mail.gmail.com>
 <E40EBF14-FD9E-49C0-A7FB-951958F72F79@zytor.com>
 <CAKv+Gu8i4KuXYQZA5noTomj6-chZcuuDEQubOJznyP1DR=+VTw@mail.gmail.com>
 <0568D1D7-B6AA-437C-ADCE-A86D7A2E4722@zytor.com>
 <20150926195755.GC3144@codeblueprint.co.uk>
 <BFDFFBC6-C6CA-4035-8E29-C7220533A787@linaro.org>
 <F1F37F57-7D03-4FC2-955E-7E8C82540A24@zytor.com>
 <CALCETrUA6k-oHzuWA54VzEA1v63b5--JPCCuBoOxLisOtjUn+g@mail.gmail.com>
 <20150927180633.GA29466@srcf.ucam.org>
 <20150928061646.GA21690@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150928061646.GA21690@gmail.com>
Sender: stable-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>
Cc: Andy Lutomirski <luto@amacapital.net>, "H. Peter Anvin" <hpa@zytor.com>, Denys Vlasenko <dvlasenk@redhat.com>, Leif Lindholm <leif.lindholm@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>, stable <stable@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Brian Gerst <brgerst@gmail.com>, Dave Young <dyoung@redhat.com>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Linus Torvalds <torvalds@linux-foundation.org>, Peter Jones <pjones@redhat.com>, Matt Fleming <matt@codeblueprint.co.uk>, Matt Fleming <matt.fleming@intel.com>, Borislav Petkov <bp@suse.de>, "Lee, Chun-Yi" <jlee@suse.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, James Bottomley <JBottomley@odin.com>
List-Id: linux-efi@vger.kernel.org

On Mon, Sep 28, 2015 at 08:16:46AM +0200, Ingo Molnar wrote:

> So the question is, what does Windows do?

It's pretty trivial to hack OVMF to dump the SetVirtualAddressMap() 
arguments to the qemu debug port. Unfortunately I'm about to drop mostly 
offline for a week, otherwise I'd give it a go...

-- 
Matthew Garrett | mjg59@srcf.ucam.org
