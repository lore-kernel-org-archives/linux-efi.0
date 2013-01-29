From: Lingzhu Xiang <lxiang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: efivarfs allows non-canonical GUID and duplicate filenames
Date: Tue, 29 Jan 2013 13:46:08 +0800
Message-ID: <51076220.5080001@redhat.com>
References: <1351237923-10313-1-git-send-email-matt@console-pimps.org> <1351237923-10313-2-git-send-email-matt@console-pimps.org> <51022DD7.4010701@redhat.com> <20130129044418.GD14395@srcf.ucam.org> <51075B56.5050408@redhat.com> <20130129052532.GA15383@srcf.ucam.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130129052532.GA15383-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Cc: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matthew Garrett <mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Andy Whitcroft <apw-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Jan Beulich <JBeulich-IBi9RG/b67k@public.gmane.org>, Chun-Yi Lee <joeyli.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 01/29/2013 01:25 PM, Matthew Garrett wrote:
> On Tue, Jan 29, 2013 at 01:17:10PM +0800, Lingzhu Xiang wrote:
>> On 01/29/2013 12:44 PM, Matthew Garrett wrote:
>>>> [root@qemu-ovmf efivars]# touch BootOrder-8BE4DF61-93CA-11D2-AA0D-00E098032B8C
>>>
>>> Ha ok. Other than the change in name over unmount, does this one cause
>>> any problems?
>>
>> This demonstrates how to create two files with the same name in efivarfs.
>>
>> [root@qemu-ovmf efivars]# ll BootOrder*
>> -rw-r--r--. 1 root root 12 Jan 25 14:56
>> BootOrder-8be4df61-93ca-11d2-aa0d-00e098032b8c
>> -rw-r--r--. 1 root root 12 Jan 25 14:56
>> BootOrder-8be4df61-93ca-11d2-aa0d-00e098032b8c
>
> Huh. The firmware permits two variables with the same GUID in different
> cases?

The two files points to the same variable.

So I create a file with upper case GUID string, but the upper and lower case
are parsed to be the same binary value and saved separately in sysfs. During
remount, the binary GUID is formatted to lower case, so the upper and lower
case sysfs entries come back to efivarfs with the same name.

This is just trying to explore the impact of not having GUID validation for
filename. Not something new.
