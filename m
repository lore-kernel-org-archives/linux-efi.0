From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [REGRESSION][v4.9.y][v4.10.y] x86/efi: Only map RAM into EFI page
 tables if in mixed-mode
Date: Fri, 3 Feb 2017 08:35:22 -0800
Message-ID: <CA+55aFyv+s4w0Fnqk7SM1V0L895nCXOwMcHLDfZdsh1+9aUh7g@mail.gmail.com>
References: <31c63945-fa81-de18-941b-9021f3d9f16c@canonical.com>
 <d5f1ba6b-06ed-b5b0-1b0e-58d5f385f7c2@redhat.com> <f8b36e38-c1f6-82f8-0ed9-0c934ace44ac@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <f8b36e38-c1f6-82f8-0ed9-0c934ace44ac@canonical.com>
Sender: stable-owner@vger.kernel.org
To: Joseph Salisbury <joseph.salisbury@canonical.com>
Cc: Laura Abbott <labbott@redhat.com>, Matt Fleming <matt@codeblueprint.co.uk>, Waiman Long <waiman.long@hpe.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Borislav Petkov <bp@alien8.de>, Theodore Ts'o <tytso@mit.edu>, Arnd Bergmann <arnd@arndb.de>, Greg KH <gregkh@linuxfoundation.org>, Scott J Norton <scott.norton@hpe.com>, Douglas Hatch <doug.hatch@hpe.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, the arch/x86 maintainers <x86@kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On Fri, Feb 3, 2017 at 6:16 AM, Joseph Salisbury
<joseph.salisbury@canonical.com> wrote:
> On 02/02/2017 03:36 PM, Laura Abbott wrote:
>>
>> You might try https://marc.info/?l=linux-kernel&m=148553171703761
>> which fixed https://bugzilla.redhat.com/show_bug.cgi?id=1384238
>
> This patch resolves the bug for multiple users.  Thanks again for the
> pointer, Laura and Ard!

.. and that patch should be in mainline now (and is marked for
stable), having gotten merged with the EFI fixes pull yesterday.

               Linus
