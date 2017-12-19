From: Andy Lutomirski <luto@kernel.org>
Subject: Re: EFI crash with PCID on
Date: Tue, 19 Dec 2017 09:20:51 -0800
Message-ID: <CALCETrV1jLwC9x=KgGZ6PyCpH=XTjWJbT=2_-CqG3Ga4XrquxQ@mail.gmail.com>
References: <CALCETrUh5c0XyFrD6DR0oSEssNS8DCa8mt5AWzpixWJQe-T1yw@mail.gmail.com>
 <CALCETrWaOhWP3TzYHRcocFxL_bSyNsLq4z30w1PGkwTVEVFf_Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrWaOhWP3TzYHRcocFxL_bSyNsLq4z30w1PGkwTVEVFf_Q@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>
Cc: X86 ML <x86@kernel.org>, Borislav Petkov <bp@alien8.de>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>
List-Id: linux-efi@vger.kernel.org

On Tue, Dec 19, 2017 at 8:52 AM, Andy Lutomirski <luto@kernel.org> wrote:
> On Tue, Dec 19, 2017 at 8:52 AM, Andy Lutomirski <luto@kernel.org> wrote:
>> Hi Matt -
>>
>> Can you take a look at https://bugzilla.kernel.org/show_bug.cgi?id=198195
>>
>
> Let's add x86 people, too.

By inspection, the KVM RSM emulation is wrong.  I put details in the
bug report.  Paolo, can you take a look?
