From: Steve McIntyre <steve-nt0JYOx6u4DQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 5/5] efi: Make efivarfs entries immutable by default.
Date: Wed, 3 Feb 2016 14:20:04 +0000
Message-ID: <20160203141959.GA3319@einval.com>
References: <1454504567-2826-1-git-send-email-pjones@redhat.com>
 <1454504567-2826-5-git-send-email-pjones@redhat.com>
 <20160203141354.GH2597@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160203141354.GH2597-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Wed, Feb 03, 2016 at 02:13:54PM +0000, Matt Fleming wrote:
>On Wed, 03 Feb, at 08:02:47AM, Peter Jones wrote:
>> "rm -rf" is bricking some peoples' laptops because of variables being
>> used to store non-reinitializable firmware driver data that's required
>> to POST the hardware.
>> 
>> These are 100% bugs, and they need to be fixed, but in the mean time it
>> shouldn't be easy to *accidentally* brick machines.
>> 
>> We have to have delete working, and picking which variables do and don't
>> work for deletion is quite intractable, so instead make everything
>> immutable by default (except for a whitelist), and make tools that
>> aren't quite so broad-spectrum unset the immutable flag.
>> 
>> v2: adds Timeout to our whitelist.
>> 
>> Signed-off-by: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> ---
>>  drivers/firmware/efi/vars.c | 83 +++++++++++++++++++++++++++++++++------------
>>  fs/efivarfs/file.c          | 69 +++++++++++++++++++++++++++++++++++++
>>  fs/efivarfs/inode.c         | 32 +++++++++++------
>>  fs/efivarfs/internal.h      |  3 +-
>>  fs/efivarfs/super.c         |  9 +++--
>>  include/linux/efi.h         |  2 ++
>>  6 files changed, 163 insertions(+), 35 deletions(-)
>
>I see no mention of the benefit of using the immutable flag versus
>making all protected files read-only.
>
>Is it not possible to just make everything that needs protecting 444?
>That way users can use standard tools if they really, really want to
>delete/write to a variable. It has the added benefit of protecting
>users from trashing variables that are important for POST too (as
>opposed to deleting them altogether).

Just making them read-only won't stop people trashing things as
root. They're already owned by root anyway aren't they??

Although if we're at the stage of doing things this wat then is there
much to be gained by having a filesystem interface in the first place?

-- 
Steve McIntyre, Cambridge, UK.                                steve-nt0JYOx6u4DQT0dZR+AlfA@public.gmane.org
< liw> everything I know about UK hotels I learned from "Fawlty Towers"
