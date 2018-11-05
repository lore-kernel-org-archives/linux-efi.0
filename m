From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH V3 0/3] Unmap EFI boot services code/data regions after boot.
Date: Mon, 5 Nov 2018 14:20:59 +0100
Message-ID: <CAKv+Gu8yS=Jn1RC_1ZY4oY84p1AnXv7NumjwFdXUZKhpn1J8Ag@mail.gmail.com>
References: <20181104201019.26142-1-sai.praneeth.prakhya@intel.com>
 <CAKv+Gu_2cPZ5HKo2oDeYsLGAXgnENzWskZOcT_Z509Shbct+2Q@mail.gmail.com> <alpine.DEB.2.21.1811051419230.1566@nanos.tec.linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.21.1811051419230.1566@nanos.tec.linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>, linux-efi <linux-efi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, the arch/x86 maintainers <x86@kernel.org>, Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, Dave Hansen <dave.hansen@intel.com>, Bhupesh Sharma <bhsharma@redhat.com>, Peter Zijlstra <peterz@infradead.org>
List-Id: linux-efi@vger.kernel.org

On 5 November 2018 at 14:20, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Mon, 5 Nov 2018, Ard Biesheuvel wrote:
>> On 4 November 2018 at 21:10, Sai Praneeth Prakhya
>> <sai.praneeth.prakhya@intel.com> wrote:
>> Thanks Sai.
>>
>> I have queued these up in efi/next for now, but I'd still like a fresh
>> ack from the x86 maintainers.
>
> I've reviewed the CPA part and for the rest feel free to add
>
> Acked-by: Thomas Gleixner <tglx@linutronix.de>
>

Thanks Thomas
