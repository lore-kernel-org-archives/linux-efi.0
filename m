From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [REGRESSION][v4.9.y][v4.10.y] x86/efi: Only map RAM into EFI page
 tables if in mixed-mode
Date: Thu, 2 Feb 2017 20:34:31 +0000
Message-ID: <CAKv+Gu8g0wYDfdnnns448UZhFO-O6iyejSr13NjxPp_5wEZDQQ@mail.gmail.com>
References: <31c63945-fa81-de18-941b-9021f3d9f16c@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <31c63945-fa81-de18-941b-9021f3d9f16c@canonical.com>
Sender: stable-owner@vger.kernel.org
To: Joseph Salisbury <joseph.salisbury@canonical.com>
Cc: Matt Fleming <matt@codeblueprint.co.uk>, waiman.long@hpe.com, Borislav Petkov <bp@alien8.de>, Linus Torvalds <torvalds@linux-foundation.org>, Theodore Ts'o <tytso@mit.edu>, Arnd Bergmann <arnd@arndb.de>, Greg KH <gregkh@linuxfoundation.org>, scott.norton@hpe.com, doug.hatch@hpe.com, "stable@vger.kernel.org" <stable@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On 2 February 2017 at 20:17, Joseph Salisbury
<joseph.salisbury@canonical.com> wrote:
> Hi Matt,
>
> A kernel bug report was opened against Ubuntu [0].  After a kernel
> bisect, it was found that reverting the following commit resolved this bug:
>
> commit 1297667083d5442aafe3e337b9413bf02b114edb
> Author: Matt Fleming <matt@codeblueprint.co.uk>
> Date:   Mon Sep 19 13:09:09 2016 +0100
>
>     x86/efi: Only map RAM into EFI page tables if in mixed-mode
>
>
> The regression was introduced as of v4.8-rc8.  It also still affects
> current mainline.
>
> I was hoping to get your feedback, since you are the patch author.  Do
> you think gathering any additional data will help diagnose this issue,
> or would it be best to submit a revert request?
>

Does this patch help at all?

https://git.kernel.org/cgit/linux/kernel/git/efi/efi.git/commit/?h=urgent&id=090abfc9dc7faf3f84799f956158c8c3af149a81
