From: Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: Re: [PATCH] selftests: Add tests for efivarfs
Date: Tue, 22 Jan 2013 12:54:19 +0800
Message-ID: <50FE1B7B.9040100@canonical.com>
References: <1358500776.780948.518900415126.1.gpush@pecola> <50FD1B1E.5000208@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <50FD1B1E.5000208-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lingzhu Xiang <lxiang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Matthew Garrett <mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Hi Lingzhu,

Thanks for taking a look at the patch.

>> +	# the open-unlink test relies on deleting the Lang variable at
>> +	# present; we don't want to do this on an actual machine.
>
> It seems open-unlink already goes to delete a custom variable.

Ah, this was left over from an older version of the test. Given that 
it's already caused problems, I'll remove the QEMU check.

Unless we're planning to brick machines in other nasty ways? :)

> test_zero_size_delete can't reproduce the file lingering bug on unpatched
> 3.8-rc4.

It's not intended to reproduce this particular issue. Would you be okay 
to add a specific test for this?

Cheers,


Jeremy
