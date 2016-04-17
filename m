From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: [PATCH] efi: Use GFP_ATOMIC instead of GFP_KERNEL
Date: Sun, 17 Apr 2016 22:18:35 +0100
Message-ID: <20160417211835.GY2829@codeblueprint.co.uk>
References: <1460372009-10785-1-git-send-email-vaishali.thakkar@oracle.com>
 <20160414214949.GS2829@codeblueprint.co.uk>
 <alpine.DEB.2.02.1604150837040.2061@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1604150837040.2061@localhost6.localdomain6>
Sender: linux-kernel-owner@vger.kernel.org
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: Vaishali Thakkar <vaishali.thakkar@oracle.com>, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, Saurabh Sengar <saurabh.truth@gmail.com>
List-Id: linux-efi@vger.kernel.org

On Fri, 15 Apr, at 08:38:37AM, Julia Lawall wrote:
> 
> I looked at it a bit with Vaishali.  I wonder if it would be possible at 
> least to have only one flag? Then one wouldn't have to maintain the 
> subtle relationship between atomic and duplicates.  I'm not sure that it 
> would help Coccinelle, but at least one could see more quickly that 
> Coccinelle is giving a false positive.

Yeah, that would be a good idea.

How about we drop the @atomic parameter and simply use @duplicates to
figure out whether to perform duplicate detection, which we should
note in the comment of efivar_init() cannot be performed atomically.
Bonus points if someone can clean up the code flow too.

Otherwise, efivar_init() is done while holding a spinlock.
