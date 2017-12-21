From: Richard Ruigrok <rruigrok-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: BUG: EFI capsule loader fails as of 4.13, the capsule is not passed
 in contiguous virtual memory
Date: Thu, 21 Dec 2017 14:42:43 -0700
Message-ID: <ee80aa6b-ceac-f410-0718-c998f9c66181@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: ge.song-PT9Dzx9SjPiXmMXjJBpWqg@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

The capsule pointer passed to efi services are expected to be in contiguous virtual memory, as per the EFI 2.6 Spec section 7.5.3, excerpt below.

This issue was previously reported and fixed in 4.9 stable: 6862e6ad95e9  efi/capsule: Allocate whole capsule into virtual memory

The series "First batch of EFI updates for v4.13" includes changes that break the efi loader as it is now passing only the first physical page of the EFI capsule.  As a result efi capsule updates are failing on Centriq products.

The series by Ge Song "Make capsules in a contiguous virtual space" was verified to work. 

Ref to the spec:

"CapsuleHeaderArrayVirtual pointer to an array of virtual pointers to the capsules being passed into update capsule. Each capsules is assumed to stored in contiguous virtual memory."

-- 
Qualcomm Datacenter Technologies as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the
Code Aurora Forum, a Linux Foundation Collaborative Project.
