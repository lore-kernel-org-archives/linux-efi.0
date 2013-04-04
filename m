From: Richard Weinberger <richard@nod.at>
Subject: Re: [PATCH 1/2] efivars: Check max_size only if it is non-zero.
Date: Thu, 04 Apr 2013 18:12:39 +0200
Message-ID: <515DA677.8050805@nod.at>
References: <1365080500-13677-1-git-send-email-richard@nod.at> <3908561D78D1C84285E8C5FCA982C28F1E0987DE@ORSMSX108.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F1E0987DE@ORSMSX108.amr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Luck, Tony" <tony.luck@intel.com>
Cc: "Fleming, Matt" <matt.fleming@intel.com>, "cbouatmailru@gmail.com" <cbouatmailru@gmail.com>, "ccross@android.com" <ccross@android.com>, "keescook@chromium.org" <keescook@chromium.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "matthew.garrett@nebula.com" <matthew.garrett@nebula.com>
List-Id: linux-efi@vger.kernel.org

Am 04.04.2013 18:00, schrieb Luck, Tony:
>> Some (broken?) EFI implementations return always a MaximumVariableSize of 0,
>> check against max_size only if it is non-zero.
>
> The spec doesn't say that zero has any special meaning - so if an implementation
> returns max_size == 0 but lets you set a variable to a size > 0, then I don't think
> there is a need for parentheses or a "?" in this commit comment.

Thanks for the clarification.
Yesterday I've looked into the spec, but the >2000 pages hurt my brain. ;-)

> But if Linux silently accepts such broken EFI, then there is no feedback loop
> to let EFI implementations know that they are broken.  In other areas we have
> thrown out messages about firmware being broken ... perhaps:
>
> 	if (max_size == 0)
> 		printk_once("Broken EFI implementation is returning MaxVariableSize=0\n");
>
> would help? After all there probably *is* a maximum size - but EFI isn't telling us what it is.

Fair point. I'll add such a printk() to my patch and resend.

Thanks,
//richard
