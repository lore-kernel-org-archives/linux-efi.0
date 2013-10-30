From: Madper Xie <cxie-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/2] make all stored entries accessible.
Date: Wed, 30 Oct 2013 17:44:52 +0800
Message-ID: <1383126294-28793-1-git-send-email-cxie@redhat.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org, anton-9xeibp6oKSgdnm+yROfE0A@public.gmane.org, seiji.aguchi-7rDLJAbr9SE@public.gmane.org
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bbboson-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Madper Xie <cxie-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

1. checking type, id, psi, count and timespec when finding duplicate entries.
2. adding count and timestamp  for differentiating.

Madper Xie (2):
  pstore: avoid incorrectly mark entry as duplicate
  pstore: Differentiating names by adding count and timestamp

 fs/pstore/inode.c | 35 +++++++++++++++++++++++------------
 1 file changed, 23 insertions(+), 12 deletions(-)

-- 
1.8.4.2
