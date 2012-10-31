From: Shea Levy <shea@shealevy.com>
Subject: Re: [RFC] Second attempt at kernel secure boot support
Date: Wed, 31 Oct 2012 13:08:34 -0400
Message-ID: <50915B12.5070205@shealevy.com>
References: <1348152065-31353-1-git-send-email-mjg@redhat.com> <alpine.LRH.2.00.1210290848450.10392@twin.jikos.cz> <20121029174131.GC7580@srcf.ucam.org> <alpine.LNX.2.00.1210311444080.12781@pobox.suse.cz> <CA+5PVA63EHiXbGAox+FmJPvztSj_i7QgnDG8vdj=p0xE+dqgGQ@mail.gmail.com> <20121031155503.1aaf4c93@pyramind.ukuu.org.uk> <20121031155635.GA14294@srcf.ucam.org> <20121031170820.2b26802a@pyramind.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20121031170820.2b26802a@pyramind.ukuu.org.uk>
Sender: linux-security-module-owner@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Josh Boyer <jwboyer@gmail.com>, Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On 10/31/2012 01:08 PM, Alan Cox wrote:
> On Wed, 31 Oct 2012 15:56:35 +0000
> Matthew Garrett <mjg59@srcf.ucam.org> wrote:
>
>> 1) Gain root.
>> 2) Modify swap partition directly.
>> 3) Force reboot.
>> 4) Win.
>>
>> Root should not have the ability to elevate themselves to running
>> arbitrary kernel code. Therefore, the above attack needs to be
>> impossible.
> To protect swap you need to basically disallow any unencrypted swap (as
> he OS can't prove any given swap device is local and inside the case) and
> disallow the use of most disk management tools (so you'll need to write a
> few new management interfaces or implement the BPF based command filters
> that have been discussed for years).

Can any kernel memory get swapped? If not all root can do is mess with 
the memory of other userspace processes, which isn't a use-case that 
secure boot cares about from my understanding.

> In addition of course there is no requirement that a device returns
> the data you put on it so subverted removable media is a potential issue.
> Or indeed just cheap memory sticks that do it anyway ;)
>
> Oh and of course the file systems in default mode don't guarantee this so
> you'll need to fix ext3, ext4 8)
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-efi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

