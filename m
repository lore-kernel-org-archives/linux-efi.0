From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/2] x86/efi: Map EFI memmap entries in-order at runtime
Date: Sat, 26 Sep 2015 13:19:15 -0700
Message-ID: <F1F37F57-7D03-4FC2-955E-7E8C82540A24@zytor.com>
References: <1443218539-7610-1-git-send-email-matt@codeblueprint.co.uk> <1443218539-7610-2-git-send-email-matt@codeblueprint.co.uk> <20150926055643.GA25877@gmail.com> <CALCETrUeGAedCKcSCvedyooamr6-tyfb3-b3uYDZG+k3Q_v9rw@mail.gmail.com> <E40EBF14-FD9E-49C0-A7FB-951958F72F79@zytor.com> <CAKv+Gu8i4KuXYQZA5noTomj6-chZcuuDEQubOJznyP1DR=+VTw@mail.gmail.com> <0568D1D7-B6AA-437C-ADCE-A86D7A2E4722@zytor.com> <20150926195755.GC3144@codeblueprint.co.uk> <BFDFFBC6-C6CA-4035-8E29-C7220533A787@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <BFDFFBC6-C6CA-4035-8E29-C7220533A787@linaro.org>
Sender: stable-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>, Matt Fleming <matt@codeblueprint.co.uk>
Cc: Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Matt Fleming <matt.fleming@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "Lee, Chun-Yi" <jlee@suse.com>, Borislav Petkov <bp@suse.de>, Leif Lindholm <leif.lindholm@linaro.org>, Peter Jones <pjones@redhat.com>, James Bottomley <JBottomley@odin.com>, Matthew Garrett <mjg59@srcf.ucam.org>, Dave Young <dyoung@redhat.com>, stable <stable@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Borislav Petkov <bp@alien8.de>, Andy Lutomirski <luto@kernel.org>, Denys Vlasenko <dvlasenk@redhat.com>, Brian Gerst <brgerst@gmail.com>, Andrew Morton <akpm@linux-foundation.org>
List-Id: linux-efi@vger.kernel.org

Sadly a lot of firmware is known to fail in that configuration :(  That was very much our guest choice.

I don't actually think it is all that infeasible to keep relative offsets consistent for the regions we have to map. PMD_SIZE is not a very large chunk so it could be a problem.

On September 26, 2015 1:09:17 PM PDT, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
>
>> On 26 sep. 2015, at 12:57, Matt Fleming <matt@codeblueprint.co.uk>
>wrote:
>> 
>>> On Sat, 26 Sep, at 12:49:26PM, H. Peter Anvin wrote:
>>> 
>>> It is still a hack unless all relative offsets are preserved.  That
>>> is actually simpler, even: no sorting necessary.
>> 
>> Unless I'm missing something, preserving relative offsets is exactly
>> what we do today, modulo PMD_SIZE gaps.
>> 
>
>I think what Peter means is preserving the relative offsets inside the
>entire 1:1 space.
>
>This is not at all what we do currently, and i don't think it is
>generally feasible on 32-bit (since the physical range may conflict
>with the virtual kernel mappings)
>
>However, on 64 bit (both arm and x86), this boils down to not calling
>setVA() in the first place, which i'm all in favor of.

-- 
Sent from my Android device with K-9 Mail. Please excuse my brevity.
