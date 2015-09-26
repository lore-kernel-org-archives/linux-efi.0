From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/2] x86/efi: Map EFI memmap entries in-order at runtime
Date: Sat, 26 Sep 2015 12:49:26 -0700
Message-ID: <0568D1D7-B6AA-437C-ADCE-A86D7A2E4722@zytor.com>
References: <1443218539-7610-1-git-send-email-matt@codeblueprint.co.uk> <1443218539-7610-2-git-send-email-matt@codeblueprint.co.uk> <20150926055643.GA25877@gmail.com> <CALCETrUeGAedCKcSCvedyooamr6-tyfb3-b3uYDZG+k3Q_v9rw@mail.gmail.com> <E40EBF14-FD9E-49C0-A7FB-951958F72F79@zytor.com> <CAKv+Gu8i4KuXYQZA5noTomj6-chZcuuDEQubOJznyP1DR=+VTw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <CAKv+Gu8i4KuXYQZA5noTomj6-chZcuuDEQubOJznyP1DR=+VTw@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, Thomas Gleixner <tglx@linutronix.de>, Matt Fleming <matt.fleming@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "Lee, Chun-Yi" <jlee@suse.com>, Borislav Petkov <bp@suse.de>, Leif Lindholm <leif.lindholm@linaro.org>, Peter Jones <pjones@redhat.com>, James Bottomley <JBottomley@odin.com>, Matthew Garrett <mjg59@srcf.ucam.org>, Dave Young <dyoung@redhat.com>, stable <stable@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Borislav Petkov <bp@alien8.de>, Andy Lutomirski <luto@kernel.org>, Denys Vlasenko <dvlasenk@redhat.com>, Brian Gerst <brgerst@gmail.com>, Andrew Morton <akpm@linux-foundation.org>
List-Id: linux-efi@vger.kernel.org

It is still a hack unless all relative offsets are preserved.  That is actually simpler, even: no sorting necessary.

On September 26, 2015 11:15:57 AM PDT, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
>On 26 September 2015 at 10:20, H. Peter Anvin <hpa@zytor.com> wrote:
>> I think it "works" because the affected BIOSes don't put spaces
>between the chunks.  I have discussed this with Matt.
>>
>
>Forgive the ASCII art but perhaps an illustration might help:
>
>before the 2.5 feature, PE/COFF runtime images were remapped as
>illustrated here:
>
>                                PA                        VA
>+---------------+         +---------------+
>|               |         |               |
>| PE/COFF .text |         |    EFI        |
>|               |         |    Runtime    |
>+- - - - - - - -+    =>   |    Services   |----+
>|               |         |    Code       |    |    :               :
>| PE/COFF .data |         |               |    |    :               :
>|               |         |               |    |    +---------------+
>+---------------+         +---------------+    |    |               |
>|               |         |               |    |    |    EFI        |
>:               :         :               :    |    |    Runtime    |
>:               :         :               :    +--->|    Services   |
>|               |         |               |         |    Code       |
>+---------------+         +---------------+         |               |
>|               |         |               |         |               |
>| PE/COFF .text |         |    EFI        |         +---------------+
>|               |         |    Runtime    |         :      gap      :
>+- - - - - - - -+    =>   |    Services   |---+     +---------------+
>|               |         |    Code       |   |     |               |
>| PE/COFF .data |         |               |   |     |    EFI        |
>|               |         |               |   |     |    Runtime    |
>+---------------+         +---------------+   +---->|    Services   |
>|               |         |               |         |    Code       |
>:               :         :               :         |               |
>:               :         :               :         |               |
>:               :         :               :         +---------------+
>:               :         :               :         :               :
>
>Since the affected symbol references only exist between PE/COFF .text
>and PE/COFF .data, there is never a problem since each is PE/COFF
>image is mapped as a single region.
>However, with the new feature enabled, this no longer holds:
>                                PA                        VA
>+---------------+         +---------------+
>|               |         |               |
>| PE/COFF .text |         |    RtServices |----+
>|               |         |    Code       |    |
>+- - - - - - - -+    =>   +---------------+    |    +---------------+
>|               |         |    RtServices |    +--->|    RtServices |
>| PE/COFF .data |         |    Data       |         |    Code       |
>|               |         |               |----+    +---------------+
>+---------------+         +---------------+    |    :     gap       :
>|               |         |               |    |    +---------------+
>:               :         :               :    +--->|    RtServices |
>:               :         :               :         |    Data       |
>|               |         |               |         +---------------+
>+---------------+         +---------------+         :     gap       :
>|               |         |               |         +---------------+
>| PE/COFF .text |         |    RtServices |-------->|    RtServices |
>|               |         |    Code       |         |    Code       |
>+- - - - - - - -+    =>   +---------------+         +---------------+
>|               |         |    RtServices |         :     gap       :
>| PE/COFF .data |         |    Data       |---+     +---------------+
>|               |         |               |   |     |    RtServices |
>+---------------+         +---------------+   +---->|    Data       |
>|               |         |               |         |               |
>:               :         :               :         +---------------+
>:               :         :               :         :               :
>:               :         :               :         :               :
>
>The illustration uses gaps, but obviously, this applies equally to
>inverting the mapping order, since the PE/COFF .text and .data
>sections will end up out of order.

-- 
Sent from my Android device with K-9 Mail. Please excuse my brevity.
