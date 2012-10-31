From: Chris Friesen <chris.friesen@genband.com>
Subject: Re: [RFC] Second attempt at kernel secure boot support
Date: Wed, 31 Oct 2012 15:58:05 -0600
Message-ID: <50919EED.3020601@genband.com>
References: <1348152065-31353-1-git-send-email-mjg@redhat.com> <20121031171743.GA17652@srcf.ucam.org> <20121031173919.4fc63ddd@pyramind.ukuu.org.uk> <2548314.3caaFsMVg6@linux-lqwf.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <2548314.3caaFsMVg6@linux-lqwf.site>
Sender: linux-kernel-owner@vger.kernel.org
To: Oliver Neukum <oneukum@suse.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Matthew Garrett <mjg59@srcf.ucam.org>, Jiri Kosina <jkosina@suse.cz>, Josh Boyer <jwboyer@gmail.com>, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On 10/31/2012 02:14 PM, Oliver Neukum wrote:
> On Wednesday 31 October 2012 17:39:19 Alan Cox wrote:
>> On Wed, 31 Oct 2012 17:17:43 +0000
>> Matthew Garrett<mjg59@srcf.ucam.org>  wrote:
>>
>>> On Wed, Oct 31, 2012 at 05:21:21PM +0000, Alan Cox wrote:
>>>> On Wed, 31 Oct 2012 17:10:48 +0000
>>>> Matthew Garrett<mjg59@srcf.ucam.org>  wrote:
>>>>> The kernel is signed. The kernel doesn't check the signature on the
>>>>> suspend image.
>>>>
>>>> Which doesn't matter. How are you going to create the tampered image in
>>>> the first place ?
>>>
>>> By booting a signed kernel, not turning on swap and writing directly to
>>> the swap partition.
>>
>> Ok so the actual problem is that you are signing kernels that allow the
>> user to skip the S4 resume check ?
>
> No. The problem is principal in nature.
>
> swapoff /dev/sdb6 ; dd if=/tmp/malicious_image of=/dev/sdb6 ; sync ; reboot
>
> That would do it on my system.
> Maybe in theory you could solve this by the kernel invalidating images
> it hasn't written itself and forbidding to change the resume partition from the
> kernel command line, but that would break user space hibernation.

If the resuming kernel refuses to resume from images it didn't create 
itself, why do you need to forbid changing the resume partition from the 
kernel command line?

Chris
