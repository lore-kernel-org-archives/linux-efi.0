From: Jeremy Kerr <jk-mnsaURCQ41sdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 0/3] selftests: Add efivarfs tests
Date: Sun, 27 Jan 2013 06:47:40 +0800
Message-ID: <1359240460.10567.220444825101.0.gpush@pororo>
References: <1359240460.10567.220444825101.0.gpush@pororo>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1359240460.10567.220444825101.0.gpush@pororo>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Lingzhu Xiang <lxiang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Hi all,

The following patches add a small set of tests to the
tools/testing/selftests directory. These cover some of the basic
functionality of efivarfs.

Comments welcome - changes 2 and 3 cover some behaviour that Matt and I
have discussed, but I'd appreciate any wider comment on the semantics
covered by these.

Cheers,


Jeremy

--
v2: Remove qemu check, add a couple of tests

---
Jeremy Kerr (3):
      selftests: Add tests for efivarfs
      selftests/efivarfs: Add empty file creation test
      selftests/efivarfs: Add create-read test
