From: Shea Levy <shea@shealevy.com>
Subject: Revisiting EFI boot stub config file support
Date: Tue, 01 Jan 2013 10:55:39 -0500
Message-ID: <50E306FB.6080607@shealevy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

Hi all,

In March last year, I submitted a patch to enable the EFI boot stub to 
read its config arguments from a file on the ESP, both to help with 
booting from livecds and to avoid having to use efibootmgr every time 
you change your boottime arguments. I ended up dropping the submission 
because I ended up coming to the conclusion that tools like rEFInd and 
gummiboot were better suited to the task of boot managing than the 
kernel itself.

Since then, however, I've received enough emails asking about the status 
of the patch that I think there is room for a simpler entrant into the 
field of linux EFI boot management. This could be in-kernel, as per my 
original patch, or a very simple out-of-kernel (but maybe distributed 
in-tree?) efi image that simply reads linux.conf and boots linux with 
those parameters. My personal bias is still toward handling this 
functionality outside of the kernel itself, but before I started the 
work I thought I'd ask here if anyone thought I should instead bring my 
old patch up-to-date.

Thoughts?

Thanks,
Shea Levy

P.S. I am subscribed to linux-efi but not lkml, please include me in any 
replies to lkml.
