From: Lingzhu Xiang <lxiang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/3] selftests/efivarfs: Add create-read test
Date: Mon, 28 Jan 2013 19:25:48 +0800
Message-ID: <5106603C.5050309@redhat.com>
References: <1359240460.11991.960193311372.3.gpush@pororo>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1359240460.11991.960193311372.3.gpush@pororo>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeremy Kerr <jk-mnsaURCQ41sdnm+yROfE0A@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 01/27/2013 06:47 AM, Jeremy Kerr wrote:
> +	if (!(rc < 0 && errno == EIO)) {
> +		fprintf(stderr, "Reading a new var should return -EIO\n");

What does the -EIO imply for reading a known empty file?

The file is empty. There is nothing to be read. No IO should actually 
happens.
The variable doesn't exist in nvram. What is the error? This won't make 
sense
for userspace.

Empty variable never exists in nvram per spec. Userspace doesn't need an 
extra
EIO to figure out this known fact. In the meantime, user would wonder if
something else has gone wrong? Returning zero for reading an empty file can
reserve EIO for something more informational.

Maybe at this time we just leave it as it is for other reasons. But at least
I don't think it's a good idea to mandate this behavior.
