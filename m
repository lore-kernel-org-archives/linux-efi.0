From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Subject: Re: [PATCH] efi: make EFI a menuconfig to ease disabling it all
Date: Fri, 15 Dec 2017 13:23:37 -0500
Message-ID: <f1007c70-caa4-8ca9-3d52-532e4302cc6e@gmail.com>
References: <20171209155252.6403-1-vincent.legoll@gmail.com>
 <20171215151910.GC3204@codeblueprint.co.uk>
 <CAKv+Gu8Jd8Z78_1SrcLvX7DKSxf9BjkJtJ+UXYi7ak_zpA3fKQ@mail.gmail.com>
 <CAEwRq=qeVDDCY+TFcbF0aeYWLzx0f-256=kwXTZbyEAkNRgUHA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAEwRq=qeVDDCY+TFcbF0aeYWLzx0f-256=kwXTZbyEAkNRgUHA@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Vincent Legoll <vincent.legoll@gmail.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Matt Fleming <matt@codeblueprint.co.uk>, Kees Cook <keescook@chromium.org>, Anton Vorontsov <anton@enomsg.org>, Colin Cross <ccross@android.com>, Tony Luck <tony.luck@intel.com>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On 2017-12-15 12:24, Vincent Legoll wrote:
> Hello,
> 
>>> This looks fine to me. Ard?
>>
>> Doesn't this break existing configs?
> 
> Would adding a "default yes" on the new menuconfig be OK.
> 
> If yes, I'd respin it for a v2
> 
Alternatively, would it not make some degree of sense to just turn the 
CONFIG_EFI symbol into the menuconfig?  It already controls all the EFI 
related stuff except GPT support (which should not be dependent on EFI 
support), so anyone who wants EFI support already has it enabled, and it 
would be a bit nicer to work with when actually configuring a kernel (It 
is rather annoying to have to effectively enable something twice).

The same (in theory) goes for pretty much any other patch like this 
where there's already a config option controlling it all that just isn't 
a menuconfig.
