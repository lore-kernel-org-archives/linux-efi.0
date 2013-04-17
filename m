From: Richard Weinberger <richard@nod.at>
Subject: Re: [PATCH] x86,efi: Implement efi_no_storage_paranoia parameter
Date: Wed, 17 Apr 2013 09:32:30 +0200
Message-ID: <516E500E.3020909@nod.at>
References: <1366153253-28572-1-git-send-email-richard@nod.at> <alpine.LRH.2.00.1304170116060.8789@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.00.1304170116060.8789@twin.jikos.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Jiri Kosina <jkosina@suse.cz>
Cc: matt.fleming@intel.com, cbouatmailru@gmail.com, ccross@android.com, keescook@chromium.org, tony.luck@intel.com, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, matthew.garrett@nebula.com
List-Id: linux-efi@vger.kernel.org

Am 17.04.2013 01:16, schrieb Jiri Kosina:
> On Wed, 17 Apr 2013, Richard Weinberger wrote:
>> +static bool efi_no_storage_paranoia;
>> +EXPORT_SYMBOL_GPL(efi_no_storage_paranoia);
>
> Is there any particular reason to export this symbol?

I saw that the other parameters in that file are exported too
and other (efi) drivers may also be interested in that symbol.
So I thought it is a good idea to export it too.

Thanks,
//richard
