From: Matt Fleming <matt@console-pimps.org>
Subject: Re: [PATCH] x86,efi: Implement efi_no_storage_paranoia parameter
Date: Wed, 17 Apr 2013 15:55:36 +0100
Message-ID: <516EB7E8.1030105@console-pimps.org>
References: <1366153253-28572-1-git-send-email-richard@nod.at> <alpine.LRH.2.00.1304170116060.8789@twin.jikos.cz> <516E500E.3020909@nod.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <516E500E.3020909@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
To: Richard Weinberger <richard@nod.at>
Cc: Jiri Kosina <jkosina@suse.cz>, matt.fleming@intel.com, cbouatmailru@gmail.com, ccross@android.com, keescook@chromium.org, tony.luck@intel.com, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, matthew.garrett@nebula.com
List-Id: linux-efi@vger.kernel.org

On 17/04/13 08:32, Richard Weinberger wrote:
> Am 17.04.2013 01:16, schrieb Jiri Kosina:
>> On Wed, 17 Apr 2013, Richard Weinberger wrote:
>>> +static bool efi_no_storage_paranoia;
>>> +EXPORT_SYMBOL_GPL(efi_no_storage_paranoia);
>>
>> Is there any particular reason to export this symbol?
> 
> I saw that the other parameters in that file are exported too
> and other (efi) drivers may also be interested in that symbol.
> So I thought it is a good idea to export it too.

I've applied this patch but I did drop the EXPORT_SYMBOL_GPL() line. If
people want access to this symbol at some future date we can address
that later.

Thanks!

-- 
Matt Fleming, Intel Open Source Technology Center
