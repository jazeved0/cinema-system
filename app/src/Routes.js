import { useMemo } from "react";
import {
  AppManageUser,
  AppManageCompany,
  AppCreateMovie,
  AppTheaterOverview,
  AppScheduleMovie,
  AppExploreMovie,
  AppViewHistory,
  AppVisitHistory,
  AppExploreTheater
} from "Pages";

const adminRoutes = [
  {
    to: "/admin/manage-user",
    text: "Manage User",
    page: AppManageUser
  },
  {
    to: "/admin/manage-company",
    text: "Manage Company",
    page: AppManageCompany,
    exact: false
  },
  {
    to: "/admin/create-movie",
    text: "Create Movie",
    page: AppCreateMovie
  }
];

const managerRoutes = [
  {
    to: "/manager/theater",
    text: "Theater Overview",
    page: AppTheaterOverview
  },
  {
    to: "/manager/schedule",
    text: "Schedule Movie",
    page: AppScheduleMovie
  }
];

const customerRoutes = [
  {
    to: "/explore/movie",
    text: "Explore Movie",
    page: AppExploreMovie
  },
  {
    to: "/history/view",
    text: "View History",
    page: AppViewHistory
  }
];

const userRoutes = [
  {
    to: "/history/visit",
    text: "Visit History",
    page: AppVisitHistory
  },
  {
    to: "/explore/theater",
    text: "Explore Theater",
    page: AppExploreTheater
  }
];

export function getRoutes({ isAdmin, isCustomer, isManager }) {
  return [
    ...userRoutes,
    ...(isAdmin ? adminRoutes : []),
    ...(isCustomer ? customerRoutes : []),
    ...(isManager ? managerRoutes : [])
  ];
}

export function getAllRoutes() {
  return getRoutes({ isAdmin: true, isCustomer: true, isManager: true });
}

export function getUnauthorizedRoutes({ isAdmin, isCustomer, isManager }) {
  return [
    ...(!isAdmin ? adminRoutes : []),
    ...(!isCustomer ? customerRoutes : []),
    ...(!isManager ? managerRoutes : [])
  ];
}

export function useRoutes({ isAdmin, isCustomer, isManager }) {
  return useMemo(() => getRoutes({ isAdmin, isCustomer, isManager }), [
    isAdmin,
    isCustomer,
    isManager
  ]);
}

export function useAllRoutes() {
  return useMemo(() => getAllRoutes(), []);
}

export function useUnauthorizedRoutes({ isAdmin, isCustomer, isManager }) {
  return useMemo(
    () => getUnauthorizedRoutes({ isAdmin, isCustomer, isManager }),
    [isAdmin, isCustomer, isManager]
  );
}
