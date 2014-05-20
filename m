From: Francis Moreau <francis.moro@gmail.com>
Subject: Re: kernel 3.14.2 oops: seems related to EFI
Date: Tue, 20 May 2014 14:12:49 +0200
Message-ID: <537B46C1.8020802@gmail.com>
References: <53777F7B.8060407@gmail.com> <20140518134206.GA8040@pd.tnic> <5379AE46.3000407@gmail.com> <20140520115421.GH4798@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140520115421.GH4798@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt@console-pimps.org>
Cc: Borislav Petkov <bp@alien8.de>, LKML <linux-kernel@vger.kernel.org>, linux-efi <linux-efi@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On 05/20/2014 01:54 PM, Matt Fleming wrote:
> On Mon, 19 May, at 09:09:58AM, Francis Moreau wrote:
>>
>> I don't know, I can't really afford to configure/compile/test this new
>> kernel, sorry.
> 
> It would be useful to know whether this issue still occurs when booting
> with the efi=old_map kernel parameter.
> 

ok I can try to boot with that parameter and see if the issue happens
again. Unfortunately if it doesn't, we couldn't tell.

Thanks
