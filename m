From: Nigel Cunningham <nigel@nigelcunningham.com.au>
Subject: Re: [PATCH v2 08/16] x86/efi: Carrying hibernation key by setup data
Date: Mon, 17 Aug 2015 16:54:01 +1000
Message-ID: <55D18509.9080709@nigelcunningham.com.au>
References: <1439273796-25359-1-git-send-email-jlee@suse.com> <1439273796-25359-9-git-send-email-jlee@suse.com> <20150815170737.GA25353@Nokia-N900> <alpine.LNX.2.00.1508162321100.27871@pobox.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-pm-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.00.1508162321100.27871@pobox.suse.cz>
Sender: linux-pm-owner@vger.kernel.org
To: Jiri Kosina <jikos@kernel.org>, Pavel Machek <pavel@ucw.cz>
Cc: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, linux-pm@vger.kernel.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Matthew Garrett <matthew.garrett@nebula.com>, Len Brown <len.brown@intel.com>, Josh Boyer <jwboyer@redhat.com>, Vojtech Pavlik <vojtech@suse.cz>, Matt Fleming <matt.fleming@intel.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, "Lee, Chun-Yi" <jlee@suse.com>
List-Id: linux-efi@vger.kernel.org

Hi all.

I've rejoined LKML, so I'll try to help with reviewing PM patches. I'd forgotten how much it is a case of sipping at a fire hydrant!

Regards,

Nigel

On 17/08/15 07:23, Jiri Kosina wrote:
> On Sat, 15 Aug 2015, Pavel Machek wrote:
>
>>> For forwarding hibernation key from EFI stub to boot kernel, this patch
>>> allocates setup data for carrying hibernation key, size and the status
>>> of efi operating.
>>>
>>> Reviewed-by: Jiri Kosina <jkosina@suse.com>
>> Jiri, are you sure you reviewed these? This is not really
>> english, afaict, and efi/EFI should be spelled consistently.
> Yes, I did review the code and the fact that it is still in compliance 
> with my original idea. I think you can blame me on not reviewing 
> changelogs super-rigorously though, so all suggestions for improvements 
> are absolutely welcome.
>
> Thanks,
>

